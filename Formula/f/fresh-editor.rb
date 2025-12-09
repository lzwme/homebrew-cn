class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.27.tar.gz"
  sha256 "6433237e9ec743f2e038b80e24e093dc594b7b6c8296a7443d6c172f09a1c8e5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0e141364c8d373f19c17f8131519f50437128ee7e47b83aa0dedc25b848c01a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abe5e9400d6bb41a3bb0648db11ee42c552766582bbafe9ab0c98cf2404f596d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc5df8fde0d9e4f2b4ee3f9fb2e01622c2b10791ebdf1267ad77a7d584d8b371"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f3f51c57839d91528c2b7c508821ed14175d445a9995c90eb5156c16a183a5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4c0409cc2554dc6c3c9fb9c57de0ec657abbd0d816ca928e1c2837be7e7aaa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f4d25de406b5409d9c8f27d2fbd24785cc6e546307daebd6593a23da639db0f"
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