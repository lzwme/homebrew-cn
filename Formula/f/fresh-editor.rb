class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.52.tar.gz"
  sha256 "a454ebf90b53a0e0097b317d13a413f71549e3d1685e6607361dd63c01cd3e35"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "279919ad19cf3e395e672138b260c5317ed2786bb56520fbc2612b11442d487c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f933fbbdb0e1ff6b6b779bc01c12b23a9907b7661dca2285e7343770d61256b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39b13e87f1ca3fb15172558c37984183fd9d9c5e20a86b2a9c231af0295622fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b62f9ebe2983f9151417a8fdd99c54e5ea5a76b8acadf57bf6c90bf0c68aee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6737ef8665a94eab08f77b36d36e5ec7b679a2d00695d44eb603c6a34d6ea3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f32c178cfd6aacbd2a9c4fd6403249eccb0b7da9342232b49db4b0a917eec3"
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