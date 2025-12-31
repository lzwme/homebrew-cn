class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.67.tar.gz"
  sha256 "bf667d15f76a13ba2f04fa93bfd3aa6d14f01e5a936dbf98f6c741f4748ca201"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0623f418e791d48bbb2b18f7689f34627cd79a93637f6a82174b9cc6e3e9568"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99eb69a1a42e7fd58b9658a0d1ed9d955e9d9a49174e3ba52a0f134e35856401"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b01b95957ce526c231ae24a6b27e0db6f3525a75915c3fc7952264c671cb77a"
    sha256 cellar: :any_skip_relocation, sonoma:        "19281d784540eea99a7f07c1f85959d672c791f0bb94c82d82baaba18910353a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63a5ca7a7138df4df8e546dd29a2f2f7ed31627cb985518e132e959f79a99eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4e2ee772e0ba80cf57c03ff0ad846446eaaddfad5ff8dddd48c42445adefbc1"
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