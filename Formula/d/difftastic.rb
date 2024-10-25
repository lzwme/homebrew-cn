class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https:github.comWilfreddifftastic"
  url "https:github.comWilfreddifftasticarchiverefstags0.61.0.tar.gz"
  sha256 "8e85001e32f1fe7b2c6d164f3a654cb589c6e48b6350421df27a56919da7a185"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2b7f3f27a64c660bb67144a436ba14260dcb1e8971cfe0f81f395f1d864916c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f25870db5ae08c753c5f08f41ee7d68afadbc1632bdaaeefbd08832af7e0cd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "777bd7bf276467e41840c1549b792ff80abb656fc98724d133d44d0bda7eaedd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f992243103e51e8c0d6214594a18b33b5ade70dc3814cd2581b57ad588dfe6c0"
    sha256 cellar: :any_skip_relocation, ventura:       "e21c8dff05fde08d4f80cb2434cf9f9f5e1c86d56311d7ed4dfe6fa6d47c54e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5be52d55835ae0a9309e486d1a646dc1f2d8bf0d5e6e6757cc2891d9a961b15"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "difft.1"
  end

  test do
    (testpath"a.py").write("print(42)\n")
    (testpath"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                   1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}difft --color never --width 80 a.py b.py")
  end
end