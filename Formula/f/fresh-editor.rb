class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.21.tar.gz"
  sha256 "68a9c0db546809cc6c75e39cfeee633f72767afc051358e2c2fab88ffdc07ddc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a9ee515e545a48678d28f3677f7967cf68abc2b321c23bee98e0fe5d49ef371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73f1d1a7ade5a381b6fc919edca1033859feab80e5ef4f56de99e5649f83b288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b688588ab9efd9b9211ba8bbfeef62d4f1d715c17d2e45bbf82be36d74ba28dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc0b89c14a14ac751d29b18168f6d5b6483780b33c2f24641c13dc2800d3e365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03d1cfbef017cd4bfb76d107c94ced46e06f97004b8862e3ed79b62c4306f332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3a56c9709cefeae3c7dff8d2a55f303960f43ab196fd58fe18b6adc9ff30405"
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