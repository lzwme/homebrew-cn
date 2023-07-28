class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://ghproxy.com/https://github.com/Wilfred/difftastic/archive/refs/tags/0.49.0.tar.gz"
  sha256 "68a65c23ac0857b1a0bdd34d16605ac73fb53238504755d17fe6706c3e96af47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9257ae60220e7dcf48ec937d4f21fa2bc5f5ddca201c1ead784316d90cd72e0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efd316e0bb47d078ff9d6239e4ac917e0e0cd2c62a5ba025c4499dece906f709"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd77b203e2ab79b37c931f3ec129f58b02942072359915d4c6b3a913f41d0563"
    sha256 cellar: :any_skip_relocation, ventura:        "87c8b903a76a6eb55d3945bf9d790cbddd6d8a503b733fefc1843767859da0d2"
    sha256 cellar: :any_skip_relocation, monterey:       "af1a7c850fd04a806d33dffa3322529adfcf10e296dbf06e87acea0184b8a7e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a400b5a6caf785f29da3555d768fb9db420b1ba40110d6945ae941225fa2811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "434325cc9df33795e12f509fda1e0f5da85bcf89e24934e70464b0db24589833"
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