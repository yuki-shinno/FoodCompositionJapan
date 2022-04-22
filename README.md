# FoodCompositionJapan

Rで日本食品標準成分表を使用できるパッケージです。主に下記が含まれます。
- 『日本食品標準成分2020年版（八訂）』のデータ（本表）
- 食品成分表を使用するための各種関数

## 使い方

### インストール方法
まだパッケージとしての体裁が整っていないため，CRAN経由ではダウンロードできません。`devtools`を使用し，ダウンロード・インストールしてください。

``` r
library(devtools)
install_github("yuki-shinno/FoodCompositionJapan", force=TRUE)
library(FoodCompositionJapan)
```

### 食品成分表について
下記のコードで食品成分表にアクセスできます。

``` r
data("food_composition")
```

### 基本的な使い方
このパッケージを使用し，栄養計算を行うためには，下記の手順で行います。

#### １．まず下記のように「食事」のデータフレームを作成します。
``` r
my_meal <- createMeal()
```

#### ２．１で作成した「食事」のデータフレームに「食品」を追加します。食品番号と重量を指定します。
``` r
my_food <- createFood(
  food_number = '01001',
  weight = 100
)
```

追加したい食品の食品番号が不明な場合は，下記のような関数を使用することで，GUIから食品を検索できます。
```r
my_food <- createFoodBySearch()
```

#### ３．栄養計算を行う
下記のコードを実行することにより，栄養計算結果が取得できます。
``` r
ret <- calcNutrient(food_list = sample_meal_day1)
```
