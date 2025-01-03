class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https:github.comshshemitabiew"
  url "https:github.comshshemitabiewarchiverefstagsv0.8.0.tar.gz"
  sha256 "d8f5a7ab8373d8cb1ca88a8d921f0ce0f44ff34bf5fdbf6afd170594ba28df9a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "815f399df1e5befbf55d5f1c3b11c39d6e2108eb13cc9524a8245335ce3a4bde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "634f0294db4bbb963e0d9fe57f155bb998a7f1833b67021f43c01dd8da1a028f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ff55c7674f9a9c0b4b970d4a40527b3d5f9f85bec588fba7cbd03592f56284e"
    sha256 cellar: :any_skip_relocation, sonoma:        "16cc5896eaed00c89ad7395fba1da2ebf7229e25828435cb54aaaf38533fa3ba"
    sha256 cellar: :any_skip_relocation, ventura:       "7d4efcc66f4411407320c49748f9a5bec1b3ab8ed770d36cf3bde0c3bf2947d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d4ea5338ff22a6f87c80773914f3361e8f07c57d697e2fae591ee2b9998329d"
  end

  depends_on "rust" => :build

  conflicts_with "watcher", because: "both install `tw` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "targetmanualtabiew.1" => "tw.1"
    bash_completion.install "targetcompletiontw.bash" => "tw"
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

    assert_match "you think?", (testpath"output.txt").read
  end
end