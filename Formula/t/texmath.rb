class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8.4/texmath-0.12.8.4.tar.gz"
  sha256 "fb53e9dcc559ff045ebf2e83a1fc6fc599fae59b9c43dda78145872dd8a671de"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2fb02a70c7cd43d2a019688eab17a191f5582aa561a2ce4c9b07421cc08a8aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da1ebe49b69604038945f234f74c5b7b426d3338f6dbfbc10cd9312650a64313"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "273f8e820054e39be8e79fc8a6db2b371461a2e8c7a6b5381ccaf37148a9bd69"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a620ce0315807914ddc32083f208eca93dac5ea9d5bec0dc3cf54ea3c79e8a2"
    sha256 cellar: :any_skip_relocation, ventura:        "0f4161456b5be936834daaaeecf7796a5f1dcc15df30a8aa0386e2d6b5791898"
    sha256 cellar: :any_skip_relocation, monterey:       "f861aa05cce7bf97c7018ba5481f0bd5003e137401f75198ab9725ce33076224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a3f5b699942c6c209ef08cd705bb1e648d4cc8f4cba3ed7787486fe7b74296d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "-fexecutable"
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end