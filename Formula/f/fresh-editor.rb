class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.26.tar.gz"
  sha256 "f254934d732c2971705dd38a1282a450854e917462fc3185218ef205f24c8bce"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c94d689149134384ad96373b4959de0aaa14ec899b7a44b6e7d5d90df3b01698"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03867321fe7aadc2092250944f35952ea997f14f462120d70c5fe3181be44a25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8f7941c6c43cf322377c9ba999dadf79dcb3906193b802bd6d58b9b522cf797"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7b0791f6fa182c6729f05ec247e793f4d785d829e17672a8d2811fb77dfe60b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71e644e44794b54dcbc15fa6bd8d94a2cca9af5cb12a1dc55bb8f8a934988988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d0d8fa5f5d9c4a98857349f4cd470a02750a998ea7138f6848dbb69f29d69d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    # Test script mode: type text, save, and quit
    commands = <<~JSON
      {"type":"type_text","text":"Hello from Homebrew"}
      {"type":"key","code":"s","modifiers":["ctrl"]}
      {"type":"quit"}
    JSON

    pipe_output("#{bin}/fresh --script-mode --no-session test.txt", commands)
    assert_match "Hello from Homebrew", (testpath/"test.txt").read
  end
end