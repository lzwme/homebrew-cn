class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://ghproxy.com/https://github.com/ocaml/dune/releases/download/3.8.3/dune-3.8.3.tbz"
  sha256 "e2b78ba805cef320f0b5978c4d371fde8ab82546d5ae51a0cb451042193b5bf8"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d11afe8572c450bfe04d888ee5d6e598eb642bbb09c2a97132e6e145f732657a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38056c4303a3496208baff4b6d7ce1440de17334b5d1819dfcd957e300d7eeae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f25a421801bcef68211ec4984fdbdc1663528f5d9852eabd44bc7d449c8a2125"
    sha256 cellar: :any_skip_relocation, ventura:        "94bc5049cc6f6b3ba387e3f4cc7e25c036b4522ec7fa3b12ad316417d90928d2"
    sha256 cellar: :any_skip_relocation, monterey:       "1e9597f966c0ad87989d0be67bb2d5ac0d1d4eccc3d25c90a9a02c0c7fd33165"
    sha256 cellar: :any_skip_relocation, big_sur:        "a31581a3c84086b3aea0f12997042908d1c82146fe7ca3d14f2db80116cdcad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea828bc057e32e7d8dee9c906f55406406e056da688f0d372f5bd88b004d854"
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "make", "release"
    system "make", "PREFIX=#{prefix}", "install"
    share.install prefix/"man"
    elisp.install Dir[share/"emacs/site-lisp/*"]
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath/"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin/"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath/"_build/default/#{target_fname}")
    assert_match contents, output
  end
end