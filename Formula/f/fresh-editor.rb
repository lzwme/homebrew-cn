class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.43.tar.gz"
  sha256 "0cb3f60d7221a1cdd5dc48abd9729c5c99bf90e275a1436e1253e30522ec1c40"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9aa221beb0edf0520730cda41a09ef56fbec293d96d080ffe4768898a564690"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "386f9480122605e959e27303c6aa9e0adcfe7e0ea49abfa60a8169c5f8bdd3d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba0017fe8f37786012b4ad1aae867946dc992b167d1e0284b845bf00583ecda3"
    sha256 cellar: :any_skip_relocation, sonoma:        "24cd996c8e77a5d1689d1cdc0e9e66396064384e4b87f909bbdbe687ea6aebde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f2c299944ba81c120cb47a34bc2a4ba6d02ff966e7897de1c434ff0aa388239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca5c550d8f4f0f70aa78922b8c134748116010569979f0b0ef46965a6880d76d"
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