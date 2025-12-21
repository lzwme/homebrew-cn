class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.56.tar.gz"
  sha256 "38f1e5074ce8b10f0a4a49806b28a59447c150a8607b55b55b5233b7e43525c9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "387b2287c307b6d1bb8932306c84cd902382d95a5d1d02409c0f2918559a495b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c1e81400f90fbf1b52c5ae9f9bf33390744c78127c32b2e2d6be7988a4e8593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b210bcbb139ee4984b0a3dff69111bd98e75549e5271877022b2819039b11ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "105ce9256efa68be5405b6b2a6df184122a3a656087608cbc994a3ef91ab356b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff9b96a9600400d53dcbae1680ffda54e11d044e2db2d1b132f319b0b9b3deef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40fcd7344198cc805d722444ae8e37e7a7413f5abde9695f2e8aed05d21b6cba"
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