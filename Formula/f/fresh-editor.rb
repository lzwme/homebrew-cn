class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "9207740b44840e66a750cf992a8c998512b8809c5e338b253e85fae7b1d10b8d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ed1b3dc57e41fba5ed261f7628a367c7b984f988e74ed5e3d1cfbce2ae78617"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "222a9f491bf04e831c6ae5ea5275d6e5baf6a5ded4e240415d2dbdc98373cf48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ee6283341f1f50b0657060e16f761beba5781c2128cb2615fab5a17aecefdf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a63ab6528f42ce7df77a77045281c76918a4931a4addc074b15772a594f97fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ebd4aaa82885c109d6627a73da333e93548aba9499a3a9e3aca0b35bb54c407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb1b5e889465b7dd7997c2c8e166e078afbab824867d9d933b298a6fe5ff7497"
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