class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.27.0.tar.gz"
  sha256 "e5b16179b756e42f78e76597f5e7356fc6f984a4bc7f3e274bd820cce5a8c7fc"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd46eb365663646f1ed5d4f1d39c7924f329d16520eeed5d32dcdbe965ec9b76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39a94e307d942842c16f214151a3a3ee5ab5f586683e4e0eb4c5e16d42983d4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd918f8372111250a29053398f2c43be8482d5f023b09a6304fafdad2b1dc3e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "39c87c9d9574d41081fb9f74918356c31ea3660ea147ddaae57b2ea800fcba56"
    sha256 cellar: :any,                 arm64_linux:   "1ac8347c23742d4ff2c348f5e4dc667e887252fd5f8fd2a2af9c51334b263c0b"
    sha256 cellar: :any,                 x86_64_linux:  "a3882cb16be94b7fec472f58f76b02cb7b91db725860074cd2f9947e5d468db5"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end