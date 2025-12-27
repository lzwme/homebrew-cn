class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.64.tar.gz"
  sha256 "c2b1d892c38829ba128eef1dd46ad13a7636187e06d32928e003c906bb579df9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cd4f6dc499ea9b77df88b4eaecf60bc4f49136328257c44397570f0b01815eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18418accc7ebec85f9b59fbc0fcdce797b6de0e29530e037ce6fb89bcfd32992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b02d12ca8ee152f659e5fb5c169601ecadc7f3da46687370393a94ac80798990"
    sha256 cellar: :any_skip_relocation, sonoma:        "279e771f81c0e4a6aa79f4f25d443ed5c19c014794e9ce3aba01d690d976a701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "420b07ad39f8896c81a39d4909923e1cb99030ad6d666e0cc31f23e00536f21f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "178fb084181055416928dc4a667e6f271a15a1db43136a1df562f56428c7184d"
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