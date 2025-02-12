class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https:github.comshshemitabiew"
  url "https:github.comshshemitabiewarchiverefstagsv0.8.2.tar.gz"
  sha256 "b4f35ea8e7cf320b88b4e5c2060305190fad5126285a14bc044207e4ddd487b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "926824d4b680f321b12c10d7bb6c7ba5a23f9de79ec56584bdcb4c1fcf59938a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e934eb33a68b013b85d32bb1f0039b77d401b3a0b7830273d07e9cc92f728f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "880a3a5a40955e5c647abc5d507a2f11e693789b4cf51f11bf046c3e21f34ece"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a5e4f53f402f7f339f4168f24f58f1b44ab6b7160995e9d702cf41731e92add"
    sha256 cellar: :any_skip_relocation, ventura:       "077ee1d0f053b8bd97edbadb682e0cb1ff99d69a231db70e0b956140c2d6e190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdf591acec02fcf3472ea07263da8a27584758f29646c658424d9278d0395c41"
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