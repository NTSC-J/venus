#!/bin/bash
# the next line restarts using tclsh \
#exec tclsh "$0" "$@"
#Hirotaka Takayama
#Date : 2013_08~

# トップモジュール名とファイル名の変数を作っておく。
set base_name "execute"
set rtl_file "../ex/execute.v"

# クロック、リセットの変数を作っておく。
# HDL 中の信号名を書いておく。
set clock_name "clk"
set rst_name "rst"

# ここは合成時に引用されたライブラリでできたモジュールを指定しているところ
# 再コンパイル時に最適化するために指定することがある。
#set module_name "DW02_mult"

########################################################################
# Setup-Library# #合成ライブラリの指定
# 毎回ライブラリの設定をやるのなら、ホーム直下に
# ".synopsys_dc.setup" というファイルを作って、そこで設定をやっても良い。
# .synopsys_dc.setup は最初に実行される。
########################################################################
# ファイルは全て相対パスで指定する。
# 環境を変えたり、バージョン違いをコンパイルする場合に、
# 相対パスの方が都合が良い。
# なお、ここで DB というディレクトリ名にしているのは
# Design Compiler の標準のライブラリは *.db という拡張子をとり
# db 型式と呼ばれるため。
# 別の名前でも判りやすければ変えて良い。
# なお、このライブラリは他のツールでも使う事があるので
# 一つ根本に近いディレクトリにしておく方が整理しやすい。
set_min_library ../DB/slow.db -min_version ../DB/fast.db

# 最終的には slow.db (一番遅い条件)で合成する
set target_library "../DB/slow.db"

# 次の行は加算器等の演算器を構成するための
# Design Compiler 組み込みのライブラリなので、
# ディレクトリ指定は無い。
set synthetic_library "dw_foundation.sldb"

# 二つ合わせて合成時のライブラリを指定する。
set link_library [concat "*" $target_library $synthetic_library]

# GUI で回路図を表示するときのライブラリ。
# 製造プロセスによって特に提供されてないときは、
# Design Compiler 組み込みのものを用いる。
set symbol_library "generic.sldb"

# 合成中にできた中間的なライブラリを置くところ。
# 合成作業用のディレクトリで良い。
define_design_lib logic_synth -path ./logic_syn

#define_design_lib logic_synth -path ../

####################################
# verilogファイルの読み込み
# System Verilog construct
####################################
read_file -format sverilog $rtl_file

####################################
#Design Attributes  #トップ階層をcurrent_designで指定
####################################
analyze -format sverilog $rtl_file
elaborate $base_name

# 古いバージョンの dc_shell では current_design は何処でも利いたのだが
# 今のバージョンでは今 current_design になっているモジュールを指定しても
# エラーになるようだ。
#current_design $base_name

# 場合によっては読み込んだ後に論理圧縮する。
# set_flatten を指定すると階層の無い積和論理形にする。
# しかし通常はこのような論理圧縮は意味が無いことが多い。
#set_flatten true -design [current_design] -effort medium -minimize none -phase false

# set_ctructure を有効にすると、中間変数を挿入して共有できる部分を探す。
# 再利用できる部分は既にソースコード中に書かれている事が多いので、
# これもあまり有効で無い事が多い。
#set_structure true -design [current_design] -boolean true -boolean_effort high -timing true

# インスタンスの実体化
# 内部で同一のモジュール複数回呼び出すときは、
# 独立したコピーを作り出して別々に合成するか、
# 一回だけ合成してそれをコピーするか選択する。
# 独立したコピーを生成する場合は uniquify コマンドを用いる。
uniquify

# 先にサブモジュールを合成してからそれをコピーする場合は、
# characterize 上位インスタンス/下位インスタンス0
# と指定してその一つを実体化させ、次いで
# current_design そのインスタンスの元となるモジュール
# と指定してから
# compile
# したのち
# set_dont_touch {上位インスタンス/下位インスタンス0 上位インスタンス/下位インスタンス1}
# の様にこれ以降変更しないインスタンスを指定する。

# 階層破砕
# 内部の改装を取り払って最適化したいときは、current_design を一つ上のインスタンスに指定し、
# ungroup 階層を破砕したいインスタンス
# と指定すればそのインスタンスは分解される。
# 細かいモジュールが沢山詰め込まれているような場合に有効。

####################################
## set constraints
## 制約条件の指定
## 動作速度や面積の指定に従って論理合成される。
####################################

#current_design $base_name
#使用するtarget_libを指定
# 遅い方の指定だけでは無く速い方の指定も必要。
# 信号が早く着きすぎてしまうのも問題となるため。
set_operating_conditions -min fast -min_library fast -max slow -max_library slow


# time(ns), design名 1.0
# 信号の最大遷移時間を指定。
# これより緩やかになってしまう場合は制約を満たしてないと判断する。
set_max_transition 1.0 $base_name

# fanout(1出力に対する最大の入力数) 4より6のほうが面積は小さく、そして遅くなる(まあ当然
set_max_fanout 4 [current_design]

#DW02_mult(Multiplier)のpparchを使うための制約設定1
#set_max_delay -from [all_inputs] -to [all_outputs] 0
#set_max_delay 0 [all_outputs]


#set_implementation pparch [find reference fix1]
#階層破壊前、セルが下記のような状態
#set_implementation pparch step1fix/DW02mult


# 合成への指示　面積の目標を0にする。
# なぜか伝統的に面積 0 で上手く合成できるようになっている。
set_max_area 0


## ----- 重要 ----- ##
## 使ってほしくないセルを指定 ##
## TLAT_X1は意図しないラッチができる可能性があるので使用しない
set_dont_use slow/TLAT_X1

## 以下のセルは遅いため、使わない方が論理の段数は
## 動作速度は速くなる。
## 余裕が有ったらこれらを使ったときと使わないときで比較してみると良い。

## *4_X* の一部はpMOSが滅茶苦茶遅いので使用しない
## OAIの多数入力も使用しない
set_dont_use slow/NAND4_X1
set_dont_use slow/NAND4_X2
set_dont_use slow/NAND4_X4
set_dont_use slow/NOR4_X1
set_dont_use slow/NOR4_X2
set_dont_use slow/NOR4_X4
set_dont_use slow/OR4_X1
set_dont_use slow/OR4_X2
set_dont_use slow/OR4_X4
set_dont_use slow/OAI33_X1
set_dont_use slow/OAI222_X1
set_dont_use slow/OAI222_X2
set_dont_use slow/OAI222_X4

##多入力のAOIが遅いため使わない
set_dont_use slow/AOI221_X1
set_dont_use slow/AOI221_X2
set_dont_use slow/AOI221_X4
set_dont_use slow/AOI222_X1
set_dont_use slow/AOI222_X2
set_dont_use slow/AOI222_X4
#少し遅いため使わない
set_dont_use slow/AOI22_X1

#遅いのでいらない、AND4_X1のみで良い
set_dont_use slow/AND4_X2
set_dont_use slow/AND4_X4


####################################
## クロックを指定する
####################################
#current_design $base_name

# 仮想クロックを nsec で指定する。
create_clock -period 4.5 $clock_name

# クロックラインを論理合成では触らないようにする。
# クロックラインは配置配線ツールが物理的な位置を考慮して合成する。
set_dont_touch_network [find clock $clock_name]

# また、合成時にはクロックラインの遅延をゼロとし、
# 理想的な配線として合成しておく。
set_drive 0 [find port $clock_name]

# クロックラインを理想的配線としたため、
# クロックラインの遅延を論理合成中に計算する代わりに、
# 仮想的なクロックスキューを設定しておく。
# これはライブラリや回路の大きさを勘案して値を決める。
# 過去の設計データの蓄積があれば誤差は小さめにできるが、
# データが無い場合は大きめに設定して配置配線の結果を見ながら調整する。
set_clock_uncertainty -setup 0.03 [find clock $clock_name]
set_clock_uncertainty -hold 0.03 [find clock $clock_name]

# リセット信号の設定
# リセットも合成時には理想的な配線として、
# 配置配線ツールによって実際の木状配線を作ることが多い。
set_ideal_network [find port $rst_name]
set_dont_touch_network [find port $rst_name]
set_drive 0 [find port $rst_name]

##set timing　出力のVIOLATEをなくす
#set_output_delay -0.32 -clock CLK [find port "Fpo[*]"]

#holdを設定
set_fix_hold $clock_name

####################################
## Compile
####################################

# 論理合成、合成後ネットリストの出力
# compile -ungroup_all は階層構造破壊
# -incremental は前の論理合成を参考にして論理合成する
# 最初は -map_effort_medium -area_effort low で
# 仮の合成を行ってエラーを検出する。
# 以前は -map_effort low があったが、今は無くなっている。
compile -map_effort medium -area_effort low

# 使わないポートを削除
# これはライブラリに含まれてはいるが使って無いポートを削除する目的で使う。
# RTL 上に使って無いポートがあるのは望ましくない。
remove_unconnected_ports -blast [find cell "*"]

#DW02_mult(Multiplier)のpparchを使うための制約設定2
#dw_foundation.sldb/DW02_mult/csa ではだめらしい
#set_dont_use [find implementation dw_foundation.sldb/DW02_mult*/csa]
#set_implementation pparch step1fix/DW02mult

# 再コンパイル
# 以下が本番の論理合成である。
# 制約条件のキツさや回路規模によって試行回数を変える
#compile -ungroup_all -map_effort medium -area_effort high -inc
compile -map_effort medium -area_effort high -inc
compile -map_effort medium -area_effort high -inc
compile -map_effort high -area_effort high -inc
#compile -map_effort high -area_effort high -inc -inc
#compile -map_effort high -area_effort high -inc -inc -inc

#
# 以下はオプションである
# 場合によっては有効だが、試行錯誤は避けられない。
#

# 演算器ライブラリによってできた階層を破砕
# designwarelibをungroup

#set_ungroup [find cell *DW*]


#さらにincrementalコンパイル
#compile -map_effort medium -area_effort high
#compile -map_effort high -area_effort high -inc
#compile -map_effort high -area_effort high -inc -inc
#compile -map_effort high -area_effort high -inc -inc -inc


#compile -ungroup_all -map_effort medium -area_effort high -incremental

#######################################################################
## Write Netlist
## 合成結果の書き出し
## write コマンドで結果を書き出す。
## 以下では Verilog HDL 型式を指定している。
#######################################################################
write -format verilog -hierarchy -output ${base_name}.vg

# verilog HDL の拡張子は通常 .v であるが、
# ゲートレベルという意味で .vg を用いたり、
# ネットリストという意味で .vnet を用いたりする。

####################################
## 以下、メモなど
####################################
###dc_shell-xg-t -f synth_fpcalc.tcl

#/usr/eda/synopsys/syn/libraries/syn/dw_foundation.sldb
#translate

#もし後からdont_useを消す（つまり使うようにする）ときはこれを設定
#remove_attribute slow/NAND4_X1 dont_use


