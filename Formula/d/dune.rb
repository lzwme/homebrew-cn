class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https:dune.build"
  url "https:github.comocamldunereleasesdownload3.17.0dune-3.17.0.tbz"
  sha256 "2c3aa6c41ed39e3d6c1a292d75f4806bd80310841afc51673aa59ce9c816507c"
  license "MIT"
  head "https:github.comocamldune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab88c2da4a2de5b8af27bc221196d8543b936ef074afcc6b1eaa1b036483d839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a6051f36687505dc2b05929f76287ff217b686fe071a403d26b30483c6bdacf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e66fc715576625783e27b56606164d4e8a1e6270b617b2a33c3541fcf1efd9c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b930467ac74da4c654c93e87a59c2c6918b0b72f90ccff7203ad13dcb460286d"
    sha256 cellar: :any_skip_relocation, ventura:       "94342ea9e1d76e037b4180033c85eac4a699cf0124bf903b4ffaef1c42d25730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9f652a9b10d41eee2821a88fdb0493c703a49433cfad164578aaf6ef71a8e5f"
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