class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https:github.comWilfreddifftastic"
  url "https:github.comWilfreddifftasticarchiverefstags0.53.1.tar.gz"
  sha256 "a8f8c02aea06b7ac14ed08ed88867abb6e35cd3c5088069953d3d50ccb41ffb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed20030fcd7629407273660ce84883fd3b7657af82f10e8c508283bb8d24a592"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a63e3d78b1fedd24402fc3502828ff209b2db43163332b48e457e6f64ae1ded"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df44e5f2b0da1ba837703650d12365ffb4c7edae19e6fa50d977259cdfe63ca1"
    sha256 cellar: :any_skip_relocation, sonoma:         "bac813fa48423acd62797c3b5d6a4b70da76f1d90ba268af52fb89b033df9e38"
    sha256 cellar: :any_skip_relocation, ventura:        "80d73636ed175db63ac33674644a2578af77a09d98a10240ba655973301b6ac6"
    sha256 cellar: :any_skip_relocation, monterey:       "33d84b70a7e79e0b0b5895355108856aa475124f426c76e6c1609a8647ea8a50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42085f5cd5ddd74824dd3b3457cf0f20524095a5a395c4435218406f6c0b8f82"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"a.py").write("print(42)\n")
    (testpath"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}difft --color never --width 80 a.py b.py")
  end
end