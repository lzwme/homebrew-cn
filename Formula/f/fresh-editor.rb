class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.75.tar.gz"
  sha256 "1935dd72116aa6b7be3cfe3d5c442650c3434f88fd493aa486cf2a759b453845"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bbf8f588e56d82eb7c2ea4cf3eff15115dfc1beeeef6934bc14d0d89f5d60ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7554558f737e93991a2cfc6ae5ff3c227d1bd018f721278ff5644159ab26fbc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2de5bbe4854a430cba15bcfef24fe44ee076f789ba97253bb6acaf5b03d9a2f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d1152dafa2280fcdc944210c74fefe8b46df2837ae4010c3e261ecec23b8cfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e9eb2376ece85fa90fa29bdc08145ab6402844a7bf8f722b01d1db5b4fa5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4042153defcc1cea9a382ac51435a904893dd58d82b6384e5350d2e23c675384"
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