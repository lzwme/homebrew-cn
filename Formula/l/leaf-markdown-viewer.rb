class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.28.3.tar.gz"
  sha256 "96250da66bdfd7dd2eb2879d3404dd3802872f4708e67cae40ad7b2af2b70bc8"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8512a79fd0a25ddca6a1642ef79e33533d583dc94d63fd3fc16aa0545dc1773a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2af2dab6645750c50a8add7a5edca4e25e9227aba95198b9e5a1ab193c5927ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8fb1c5127ed51d8811d709701d5c6ccc6627bfde82c263b30c72397c1f10a92"
    sha256 cellar: :any,                 arm64_linux:       "f1f7a096f0ab9bdf2c863a0d3e1d5658a8a60dc9362de12597e753de3fe2448f"
    sha256 cellar: :any,                 x86_64_linux:      "a53642db1706da677aeaad0670103fd389625e68e11d1c136d98385112d944c6"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end