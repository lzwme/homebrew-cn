class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.55.tar.gz"
  sha256 "a694c29ad9ddf5754b569b40cd7d74ffbcd3c740927710933be2bd58b7e5cf4d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40b894c93d65e44a00fcbb174a0b6d7e351fa2436b7d88e5625429ad8b3cb9b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c7cda71c779ccd7932ecb496b7d40abeb2f58ae2ea45b782566a0c98d7c4fa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6da87fc092e02761de061d32a053646fbf8a0297caa29a0ea60d68a58371bd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7628b9037c60fb12517238322ab733ef0241acabb571c13640ca26627905b9ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40a08f1e61212871bd0599f417f222c187c29a9f6adef95f5eab7970bc7b97ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e29345fe1a2c8fcc0765ca9841521fa5ee773570813b46d218206bfb3303aa7"
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