class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://ghproxy.com/https://github.com/Wilfred/difftastic/archive/refs/tags/0.48.0.tar.gz"
  sha256 "7f7a8ab73cc14a48b8d3935ea49f93a9b2f4367e99714ac7d530d9bee7b4032e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd02118d1b7d638a52fee20832b95035e90fdc0e233e11144f461ca17db3075f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ef78256693df3095f40da6b18ca9fa5054b73df3ed351b0bb27ed49a2d087a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0839d7832795205ae9e770801924cc77629ec184e197a5fd1e8b50754e9a913d"
    sha256 cellar: :any_skip_relocation, ventura:        "56f4b3dcdecfc1405c8b88f55f2fc7b520b5a7c457bb8d21d7c911574815fc54"
    sha256 cellar: :any_skip_relocation, monterey:       "44211d15aff67b19a7b1521dfdc10d6d1d255255bf821d42e08d4ac2647ea5f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c74ba7bb6bc86823d64b9e5d67f1d205a0afc646f0c2156465c59173bccfa95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cb2c97226b9a762a83aa92218d276bca3113b271708c0864f6ffa4febc71ef8"
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