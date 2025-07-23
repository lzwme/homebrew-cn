class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://ghfast.top/https://github.com/shshemi/tabiew/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "67a123d541a95a10ba18f2e0bc2e4f14c01dae818a3d6dff9ca9faa294fccafb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f3caad5dec6a4c9982088f231580f02e572aed67afaed4495687fa72865ab99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1045f99bd4453e1633dc36c667a0baa84243cff87936c683472e0dfb4668f03f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b548ed2f501e4d846257cf4f16f7a2db002b7b96e6acdd8f89841ac68fcf4857"
    sha256 cellar: :any_skip_relocation, sonoma:        "bca005e806a56341e16d362d601b37fc27bc65bf32c3e9d73af3d271156450d2"
    sha256 cellar: :any_skip_relocation, ventura:       "1751b56f5639bbcd98b70f59724ff7b27f05c32a9fffe490766c9ada9586b616"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f14a505a2f9d270a9e28cdbbe3b2a6fb4b806a955e128ed6ddf6a21ef2637d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bef526043638ab5caadc869f08c3850655eb6ddfe05088105e29b5f655d769bb"
  end

  depends_on "rust" => :build

  conflicts_with "watcher", because: "both install `tw` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "target/manual/tabiew.1" => "tw.1"
    bash_completion.install "target/completion/tw.bash" => "tw"
    zsh_completion.install "target/completion/_tw"
    fish_completion.install "target/completion/tw.fish"
  end

  test do
    (testpath/"test.csv").write <<~CSV
      time,tide,wait
      1,42,"no man"
      7,11,"you think?"
    CSV
    input, = Open3.popen2 "script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"tw test.csv"
    input.puts ":F tide < 40"
    input.puts ":goto 1"
    sleep 1
    input.puts ":q"
    sleep 1
    input.close
    sleep 2

    assert_match "you think?", (testpath/"output.txt").read
  end
end