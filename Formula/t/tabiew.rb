class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https:github.comshshemitabiew"
  url "https:github.comshshemitabiewarchiverefstagsv0.10.0.tar.gz"
  sha256 "48757f97eb0c02b0b5bf6244796da8b913b7fbd8602283865142add1cfc9f73d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f16776fac1e4af90086f9eb98542091521477aa6173ef1553100009e8fb789e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a756f95cac0129bf2d4b8fd7d2a317904eeb57da62604c78257f10f5a1edfb67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "380e5682d8b0daf4d9dcf72bb82c1b9fe0d5c3fb9ed36bb10294d5ae7384179f"
    sha256 cellar: :any_skip_relocation, sonoma:        "82d2296613547edd8597e449c1ce3a50f76fc69c8166e34938df74720d9dd277"
    sha256 cellar: :any_skip_relocation, ventura:       "6b20fdbd967194d748ab6b0ef3242b4f6bfc22847feae21c20a144a51fe8f50e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f3a90edc9df6173aafdd976c2008e8efa1befd3fae5c130d411a0078172b398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5ae0f9042c0a050b87b1a0705102e8efd05f55b63f5df275d844c5ad79a0a6e"
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