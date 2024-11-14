class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https:github.comshshemitabiew"
  url "https:github.comshshemitabiewarchiverefstagsv0.7.1.tar.gz"
  sha256 "17de20949fbdf89b116ab5270413081ebbcd54c666c7430c69f58e7b12055ecc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ba4fea1d8c66c6f835b5d5a6f5b10ab62ec748e8623ea0778c8e6fbb016075a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5b6355eccdd8b7db054475abc98091bbd16a8c2834451879f2841411d564dd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fc83daaee6786fd9d9537d7a7ad6932ea251b258598a88d2b1c7343667814c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e38b999c3d3dcffeee6c24f5663a7eb4281117283713a7237542b6769271552b"
    sha256 cellar: :any_skip_relocation, ventura:       "76f2b230c3ec123c4a4f0c76f8836a7536820fe59a1b3af70de6ed55d6e89c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c2aef080d530017409580752343eab0b74564fc8534a9fa019b12e566edeb4c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "targetmanualtabiew.1" => "tw.1"
    bash_completion.install "targetcompletiontw.bash"
    zsh_completion.install "targetcompletion_tw"
    fish_completion.install "targetcompletiontw.fish"
  end

  test do
    (testpath"test.csv").write <<~CSV
      time,tide,wait
      1,42,"no man"
      7,11,"you think?"
    CSV
    input, = Open3.popen2 "script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin"tw test.csv"
    input.puts ":F tide < 40"
    input.puts ":goto 1"
    sleep 1
    input.puts ":q"
    sleep 1
    input.close
    sleep 2
    File.open(testpath"output.txt") do |f|
      contents = f.read
      assert_match "you think?", contents
    end
  end
end