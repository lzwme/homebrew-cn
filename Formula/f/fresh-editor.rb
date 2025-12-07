class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.24.tar.gz"
  sha256 "bf34a7dbe3f7dfa497721945f9abde64a4fc60e794e803cabb87fa0931bd5731"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2039613459413506d62692fb6016f722c65a02dfc4ab9a0044346d55cc15768d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff61810c724f1fb6a75b1c7fad57343e9aa0d298323298a049ddef46d14bd1a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03324ae36fd43e5c9cdb17701bdb18880916d599e4a983292e50ec3193ccf0ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "155a94cc55a9473adedc404608456ca51ac6efc17076460f0f86e212191a271f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "794eb4c60e17b758dd0d653c0b758162954a17d10c170ae93d68a01afb7a0b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61bbfdce195f31c4c0ce99f1514260487be80773084d0129f8b5ecee36884916"
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