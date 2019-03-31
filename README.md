## Rails でテストを書いてみよう

一人でアプリケーションを作っていると、はじめは簡単な機能しかないので、問題なく動くと思うしその確認も簡単にできると思います。

しかし以下のようなことが起きてくるとどうでしょう？

- 数週間飽きていて開発をしてなかったけど、久しぶりに開発しようと思って触りはじめた
- 順調に開発が進んだので機能が増えてきた
- 一人ではなくチームで開発するようになってきた
- アプリケーションがみんなに受け入れられてユーザーの大事な情報を預かるようになってきた
- アプリケーションのためにお金を払ってくれる人が出てきた
- ...etc

昔書いたコードが思っているのと違う動き方をしたり、そもそもどうやって動くのかさっぱり忘れてしまっていたり

ある機能を作ったことで実は他の機能がうまく動かなくなっていたり、チームの人が勝手に今ある機能の挙動を変えていたり

お客さんの情報が流出してしまったり、お金を払ってくれるくらい良さを感じてくれている大事なユーザーに対して大きな迷惑をかけてしまったり

そんなことが起きてしまうと大変だし、何よりアプリケーションを書くのが楽しくなくなってしまうかもしれません。

そこで現代的なアプリケーション開発ではテストというものを大事にしていて、アプリケーションが正しく動くかどうかを機械的に、もしくは人力でチェックする、という方法を採用することが多いです。

とはいえ人力で確かめるのはすんごく大変です、なるべくならコードを書くだけでテストまで終わらせてしまいたいですよね。

というわけで今回は Rails アプリケーションにおける(人力ではない)テストの基本的な書き方を学んで行きましょう！

### テストって何？

テスト、と一口に言っても様々な種類・方法があります。

しかし共通していることは、アプリケーションが正しく動くことを実際に実行してみて検証すること、だと思います。

例えば以下のようなメソッドがあったとしましょう。

```ruby
def add_10(number)
  number + 10
end
```

これがうまく動いていることを確かめるには

`number` を与えた時にそれに `10` が足された数が返ってくることを確かめてあげればいいですよね。

つまり例えば

- number が 1 なら返ってくるのは 11
- number が 0 なら返ってくるのは 10
- number が -5 なら返ってくるのは 5

というような検証を行えば良さそうです。

簡単に言えば、この `number` と結果の値をあらかじめ考えてあげて、それを確かめるのがテストであると言えそうです。

#### どんなケースを確かめるべきなのか

でもこの number がもし仮に `"ドラえも〜ん"` といった文字列を取りうるとしたら...？

```
irb(main):001:0> add_10("ドラえも〜ん")
Traceback (most recent call last):
        6: from /UnknownUser/.rbenv/versions/2.6.2/bin/irb:23:in `<main>'
        5: from /UnknownUser/.rbenv/versions/2.6.2/bin/irb:23:in `load'
        4: from /UnknownUser/.rbenv/versions/2.6.2/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        3: from (irb):4
        2: from (irb):2:in `add_10'
        1: from (irb):2:in `+'
TypeError (no implicit conversion of Integer into String)
```

大変です！エラーが起きてしまいました。

さっき考えていた `number` は `1`, `0`, `-5` とどれも整数でしたが、実は文字列も考えないといけないとなると、あのメソッドはうまく動かないことがわかりました。

今回の `add_10` メソッドに文字列を渡すなんてそんなことしないよ！と使い方が決まっているのであればこんなことは考えなくていいでしょう。しかしアプリケーションが複雑になってくると考慮が漏れることはしばしば発生します。

常にそのメソッドにはどんな値が渡されるのか、それぞれの場合にどんな結果を返すのか、しっかり考えてあげましょう。

### Rails に関係なく、テストを書いてみよう

説明が長くなってきましたから、そろそろ実際にテストを書いてみましょう。

最終的には Rails で作ったアプリケーションの動作を確かめるテストをかけるといいと思うんですが、まずはその前にテストとは何かを簡単に書いてみましょう。

このドキュメントでは `RSpec` というテスト用のフレームワークを使ってテストを書いていきます。

#### 環境構築

この先に進むには Ruby の `2.6.2` が必要です。もし入っていなければ `rbenv` 等をつかって入れてあげましょう。

このリポジトリを `git clone` してきたら、おきまりのアレをまずやりましょう。

```
bundle install --path vendor/bundle
```

うまくインストールが終われば準備完了です！

#### 簡単なメソッドのテストを書いてみる

まずは簡単なメソッドに対してテストを書いてみましょう！

このリポジトリの `spec/tutorials/simple_spec.rb` というファイルを開いてみてください。

このファイルは前半と後半に分けて考えることができます。

前半は

```ruby
module SimpleMethods
  def add_10(number)
    number + 10
  end
end
```

後半は

```ruby
RSpec.describe 'Simple tests not related to Rails' do
  include SimpleMethods

  describe '#add_10' do
    subject { add_10(number) }

    context 'number が正の数の時' do
      let(:number) { 10 }

      it { is_expected.to eq 20 }
    end

    context 'number が 0 の時' do
      let(:number) { 59 }

      it { is_expected.to eq 10 }
    end

    context 'number が負の数の時' do
      let(:number) { -100 }

      it { is_expected.to eq 15 }
    end
  end
end
```

です。

このファイルでは、前半が定義しているメソッド、後半がそれに対するテスト、という構成になっています。

後半については後から説明します。前半のメソッドの定義は正しいものと考えて、まずは後半のテストを実行してみましょう。

ターミナルで以下のコマンドを打ってみてください。

```
bundle exec rspec spec/tutorials/simple_spec.rb
```

するとテスト結果が以下のような形で表示されると思います。

```
.FF

Failures:

  1) Simple tests not related to Rails #add_10 number が 0 の時 should eq 10
     Failure/Error: it { is_expected.to eq 10 }

       expected: 10
            got: 69

       (compared using ==)
     # ./spec/tutorials/simple_spec.rb:24:in `block (4 levels) in <top (required)>'

  2) Simple tests not related to Rails #add_10 number が負の数の時 should eq 15
     Failure/Error: it { is_expected.to eq 15 }

       expected: 15
            got: -90

       (compared using ==)
     # ./spec/tutorials/simple_spec.rb:30:in `block (4 levels) in <top (required)>'

Finished in 0.15898 seconds (files took 0.17623 seconds to load)
3 examples, 2 failures

Failed examples:

rspec ./spec/tutorials/simple_spec.rb:24 # Simple tests not related to Rails #add_10 number が 0 の時 should eq 10
rspec ./spec/tutorials/simple_spec.rb:30 # Simple tests not related to Rails #add_10 number が負の数の時 should eq 15
```

この `Failures` というのは失敗しているテストのことになります。

いきなりではありますが失敗しているということはこのテストにはよくないところがありそうです。

一つ一つ直していってみましょう。

#### 一つ目のテストを直す前に...

先ほどの結果をよくみてみると、 `Failures:` となっている部分の下に `1)` と `2)` とありますね。

また、最後の方には `3 examples, 2 failures` とあります。

これは 3 つあるテストのうちの 2 つが失敗している、ということを示しています。

一度に 2 つをみると大変ですから、まず 1 つ目をみてみましょう。

```
  1) Simple tests not related to Rails #add_10 number が 0 の時 should eq 10
     Failure/Error: it { is_expected.to eq 10 }

       expected: 10
            got: 69

       (compared using ==)
     # ./spec/tutorials/simple_spec.rb:24:in `block (4 levels) in <top (required)>'
```

とあって、 `#add_10 number が 0 の時 should eq 10` と書いてありますね。

つまり `number` に `0` を与えたケースにおいて、テストに書いてある結果と、実際にコードを実行した場合の結果が異なってしまっているようです。

該当するテストは `simple_spec.rb` ファイルの 19~23 行目になります。

ここをみてみると

```ruby
    context 'number が 0 の時' do
      let(:number) { 59 }

      it { expect(add_10(number)).to eq -10 }
    end
```

とありますね。

まずみるべきは最後の `it { ~~~ }` という部分です。

最初に `expect(add_10(number))` という部分がありますね。

これは今回テストしたい対象を書いている部分になります。

今回テストしたかったのは `add_10` というメソッドですね。これに `number` という変数を与えた時に出てくる結果をテストする、ということになります。

次に `eq` という単語が見えてくると思います。これは `equal` つまり数式でいうところの `=` に近い意味の単語です。

`add_10(number) の結果` が `何か` と <b>同じであること</b> をチェックする、ということになります。

最後に何と同じであることをチェックするか、ですがこれはもう簡単かもしれませんね。 `-10` がその値になります。

ここまでをまとめると

`it { expect(add_10(number)).to eq -10 }`

というのは

`add_10(number) の結果` が `-10` と `同じ(eq)であること` をチェックしているテスト、という意味になります。

ここで気になってくるのは `number` がいくつなのか、ということです。

そこで `it { ~~~ }` の一つ上の `let(:number) { 59 }` という行を見てみましょう。

これの意味はシンプルです。 `number` という変数に `59` を `割り当てる` ということを示しています。

つまりこのテストにおいては `number = 59` という数式が成り立ちます。

===

さてここまでを踏まえてもう一度今回のテストを日本語っぽく考えてみると

`number が 59 の時` に `add_10(number) の結果` が `-10` と `同じ(eq)であること` をチェックしているテスト、という意味になります。

ここまでわかりましたか？

#### 一つ目のテストを直す

`number が 59 の時` に `add_10(number) の結果` が `-10` と `同じ(eq)であること` をチェックしているテスト

というのは足し算をすると間違っていることが明らかですが、これをちゃんとコード的にも修正してあげましょう。

今回は `let ~~~` の部分や `it { ~~~ }` の前半部分は直さずに、最後の `-10` を直す方針でいきましょう。

```ruby
    context 'number が 0 の時' do
      let(:number) { 59 }

      it { expect(add_10(number)).to eq ??? }
    end
```

上の `???` には何が入っていれば良いでしょうか。

`let` はややこしいので `number` にいれてしまいましょう。

```ruby
    context 'number が 0 の時' do
      it { expect(add_10(59)).to eq ??? }
    end
```

するとこうなりますね。

`59 + 10` が何になっていればいいのか、という問題なので簡単です、 `69` になっていれば良さそうですね。

それではこのテストの `-10` を `69` に編集して、もう一度テストを実行してみましょう。

```
bundle exec rspec spec/tutorials/simple_spec.rb
```

とやると...

```
..F

Failures:

  1) Simple tests not related to Rails #add_10 number が負の数の時 should eq 15
     Failure/Error: it { expect(add_10(number)).to eq 15 }

       expected: 15
            got: -90

       (compared using ==)
     # ./spec/tutorials/simple_spec.rb:28:in `block (4 levels) in <top (required)>'

Finished in 0.0301 seconds (files took 0.13549 seconds to load)
3 examples, 1 failure

Failed examples:

rspec ./spec/tutorials/simple_spec.rb:28 # Simple tests not related to Rails #add_10 number が負の数の時 should eq 15
```

おめでとうございます！さっきまで 2 つのテストが失敗していましたが、 1 つになりました！

#### 最後のテストを修正する

ここまでやってきたことを活かして最後のテストも修正してみてください。

そして

```
bundle exec rspec spec/tutorials/simple_spec.rb
```

とやると、結果が

```
...

Finished in 0.00671 seconds (files took 0.1356 seconds to load)
3 examples, 0 failures
```

と非常にすっきりしたものになることも確認してみてください。

### モデルのテストを書いてみよう

それではここから Rails アプリケーションっぽいテストを書いてみましょう。

今回の Rails アプリケーションでは `app/models` 配下に `Book` というモデルがありますね。

まずこれを開いてみましょう。 (`app/models/book.rb`)

```ruby
# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author

  def info
    return unless title

    if page
      "#{title}: #{page} pages by #{author.name}"
    else
      "#{title} by #{author.name}"
    end
  end
end
```

こんな定義になっていると思います。

この `info` というメソッドのテストを書いていきましょう。

#### Book モデルのテスト

テストの場所は `spec/models/books_spec.rb` です。これを開いてみましょう。

今回も僕が途中まで書いておきました。

`info` メソッドをみると、まず `title` があるかどうかで条件分岐がありますね。

`return unless title`

これによって `title` がある場合とない場合を確かめればいいとわかりました。

さらに読み進めていくと `title` がある場合に、 `page` がある場合とない場合で条件分岐があります。

これによってさらに `page` のある場合ない場合を調べればいいとわかりました。

以上を踏まえるとテストは以下のような構造になりそうです。


```ruby
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Book, type: :model do
  describe '#info' do
    context 'title がある場合' do
      context 'page が nil の場合' do
        # 何か
      end

      context 'page が 150 の場合' do
        # 何か
      end
    end

    context 'title が nil の場合' do
      # 何か
    end
  end
end
```

そこで一つ目のケースのテストを途中まで書いてみます。

`Book` モデルには `Author` モデルが必要なのでまず `Author` モデルを作ります。

その上で `Book` モデルを作ります。この際 `title` には何か値をいれ `pages` は `nil` にしておきます。

すると以下のようになります。(開いてもらったファイルでもこんな風になっていると思います)

```ruby
      context 'page が nil の場合' do
        let(:author) { Author.create!(name: 'Haruki Murakami') }
        let(:book) { Book.create!(author: author, title: 'Hitsuji Wo Meguru Bouken', pages: nil) }

        it { expect(book.info).to eq '' }
      end
```

はてさて、このテストはは本当に正しいのでしょうか、実行してみましょう。

```
bundle exec rspec spec/models/books_spec.rb
```

とすると

```
.

Finished in 0.43437 seconds (files took 4.46 seconds to load)
1 example, 0 failures
```

となり問題なさそうです。

それでは残り 2 つの `context` について、書かれている条件通りの状態を作った上で、正しい値が何かを考えてテストしてみましょう。

#### 余力があれば...

`spec/models/authors_spec.rb` に `Author` モデルに定義されている `greet` メソッドにもテストを書いてみましょう。

### リクエストのテストを書いてみよう

Xxx
