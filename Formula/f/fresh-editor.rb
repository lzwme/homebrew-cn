class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.74.tar.gz"
  sha256 "3210743811f65b3fa59b1e74d60efb0043a4ac8984dd1209924ea163e91d281b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fce667b8e73eb76618a1364c8318c33869736d5301a3c89c9377d7491acc682a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "278092f6d39d2d137e4e3916f147cf64a70839018e40c6a21e48e0d6486485c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "410ae194953fedf8d7f931812d2fe9aed3b4b9556f81f6e602330ab8509110d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b9ce51c337764c6d473b16a97f9b1f12d3830833d259c9c3a0160c5230f8260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a86910902c2de65f0cfbc304eaa8468dd720cb4f987c34e539c731916994dfa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a1dacd824af601958e78be4c0140c98c1a80efe0f20fd353f5dfba45fd3d8b2"
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