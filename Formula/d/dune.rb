class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https:dune.build"
  url "https:github.comocamldunereleasesdownload3.16.1dune-3.16.1.tbz"
  sha256 "b781ae20f87613c2a11bd0717809e00470c82d615e15264f9a64e033051ac3de"
  license "MIT"
  head "https:github.comocamldune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988ba6399a7f512df3b1b7ba9a8b268fa86205613e21ffe626333e0b7fc70c81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38dca2bb0cb2e80f79093345c858cb2ffa90daa9276e23562ecf749cca038954"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db440744d7d549ccc16697bb3742d6995c4e79981e72abd09bec6ce57ca0aac6"
    sha256 cellar: :any_skip_relocation, sonoma:        "31131d9cce0b06cc62c44d9afae766e2ed847957b99ac79f022a4834bf4426f0"
    sha256 cellar: :any_skip_relocation, ventura:       "bd7d4b100ea8479ca8d94edd09980cb92adeef8f1c0a1575151d0235c23bb17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9396b7b3e9c99d94e76a7eeb0033b0cb069afee26502513267c1c4ae9688715c"
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "make", "release"
    system "make", "PREFIX=#{prefix}", "install"
    share.install prefix"man"
    elisp.install Dir[share"emacssite-lisp*"]
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath"_builddefault#{target_fname}")
    assert_match contents, output
  end
end