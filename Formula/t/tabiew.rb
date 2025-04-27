class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https:github.comshshemitabiew"
  url "https:github.comshshemitabiewarchiverefstagsv0.9.0.tar.gz"
  sha256 "e08655344fa0cd45d2ca367b2a4601e9aabdb7e0d6e43c508ed4e577f109dc5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "487d084a5d36fbed5a8736d35b2629f0925ec90d3c13744a97c651166d7ae895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "993301b3d8eb8428a49d541253ecc30e8d6754b2ec12e6004bb79af5c0b42b20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f5bcf49932c9f900ef75a18805bb80c22f4f920bafc673178cdb7893a244f7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fae687e3e9557f7e7ed2db4dc57e38415271813c37d89cd25486009500dd3af7"
    sha256 cellar: :any_skip_relocation, ventura:       "956bea50207efa3b035a8b19062db79b6f34b6d60e6955f3cfba622708ff39f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7173700335e2042784b22d4047a6b004873631a36420c248f0b4b7dd143951fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1fa8f19e6039bdff2cf4746150849b6a24e2eaf1c30f178f134869bdcd1f950"
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