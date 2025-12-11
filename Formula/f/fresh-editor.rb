class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.32.tar.gz"
  sha256 "fc2d083c84b1b74d76fc69993891e70d51ff65ca562ba812d68fefb34e8e8144"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be9e964c60155ae7f5eacf563cf7df5196e1ef7fafbc38ca06da8295d0222361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b388ecab1f6e4d677b4a92b634f09fa6713baa18b3db771323ccce267d63b5fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8811d02aec61c4762a9e57fba261781d0a224fbbd840514313d1b9d6c0270131"
    sha256 cellar: :any_skip_relocation, sonoma:        "82bbf22b5cb588e8f94623aecb72c66cca66176293d342f075404a38e324f6d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2394d4915d911a2c93997c055546685525709432991d0747c1fdfffcccd3bd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3404e76eca67b801576fb2bb7208619f204764ab4fd67147f332fa21988e675"
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