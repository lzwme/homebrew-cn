class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://ghproxy.com/https://github.com/Wilfred/difftastic/archive/refs/tags/0.53.0.tar.gz"
  sha256 "b5d4d92b9d2d6721c8680acdb8ed2d7545d73b094d4d63ce711d42dda5695bba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8430320760f2cb560e910afe3da6a35d8ea12620e576ef8713546d6900d9dd0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b7e27b8b7c205e0a4529e4da43ba7c2ade6f880e651c3637390bd458c9050db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "438b64df0697b64eb07bba54262d497a110f35013d82dd422d7cb7931e54f58b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee27cb85962f6c10ff8dcbbb39ac0d54ad1842bec28e4f90c31de5d7463881df"
    sha256 cellar: :any_skip_relocation, ventura:        "9c1801d519c3a3a28935a34a6a37fba7c548bf96accda06fa34ef899a8b5a3f9"
    sha256 cellar: :any_skip_relocation, monterey:       "c1c50170b802789492b898b0adb86fceb5773c234f2c245fe8b4a166675b6db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2320e5b7af7d913ba1fa0b22e571965fe83335a1dfbc57efef709ef35afab7b8"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end