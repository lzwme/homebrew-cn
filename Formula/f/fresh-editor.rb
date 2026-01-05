class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.70.tar.gz"
  sha256 "8d4f1dca2b78f094d64c3fce490713aff631e813780c5b12183491bd13214df2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3af2f8fb25342d26c0d54ad97fa3e087ae1ff76f63413010b79ff2004b3c1240"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "678c94245f5a8910f09c726c09dd8745d0a5525f00f7fda7035f8d7051523e07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97f7b7090909a34aaaff901e36564c4722ae8e1b254a47947d01cd3ed0530cce"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c484ff0e8e755b0aa50f9ebbaadb50331df159808fcd41fbfe6920f959d10fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f98dd8005f8ff4834eb148be3bb610204045261d974e339f71f7c851a759fe9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1736920bb6fe1245bed8a7c32233c11496fbf28750e3fd3c218a06cd961deb3b"
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

    pipe_output("#{bin}/fresh --no-session test.txt --log-file fresh.log", commands)
    log_output = (testpath/"fresh.log").read.gsub(/\e\[\d+(;\d+)?m/, "")
    assert_match "INFO fresh: Editor starting", log_output
  end
end