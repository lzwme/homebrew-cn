class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https:github.comWilfreddifftastic"
  url "https:github.comWilfreddifftasticarchiverefstags0.59.0.tar.gz"
  sha256 "2298ec0c480a3ec98799ecfb065403e13fa225f8ed6fca858fdf8c4efdb0dc69"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a823cda06cef9b6eded6591228019ce119a87fea62eb774171f89349c825bb17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aba6e80458c1c0b7bfd6a8f745c28f510d81113478055e42bad50cd2d8d99d6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25edba62c6588eda057ff7bf45353a8d848d537e6ba4bdb5cc7c9dce51ddb8a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "1185480126434896d719c28e2fd7362afed84a1c533b8f3b3dcd91dec7d665ab"
    sha256 cellar: :any_skip_relocation, ventura:        "05ea8ba2f2d4d3951fc95707310251f72358f2cf2b17cd7f77a83a1e24007f93"
    sha256 cellar: :any_skip_relocation, monterey:       "68a17b27b215bb5f3e9f3494c8e20ba3e087b5ac4007e7c4067b907789d0d0c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aa0c7de88e63a25a2b0bd3fb4be6c6e2aa7ba8a0e4dd41e28e0926d9fa74914"
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