class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https:dune.build"
  url "https:github.comocamldunereleasesdownload3.15.1dune-3.15.1.tbz"
  sha256 "b5b78a4a02d4dd0894234dbf718bff477fcd85e7dfdffe8ece00b9a0cf3d547b"
  license "MIT"
  head "https:github.comocamldune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d8a1f24a56a3e6b25b44948749bc00b08df631328c3e82606fcc5d1837605d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03aa4df92a690934228fc429b95ad409ae36b4c59abd0962dcb9df6fc3064afc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b1b5b4ecfeeb497f3c78a0b6ee42d5be6b29076323181cd5d1f96aa1a41c9fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "08b3f8d6404070a1a0855d1db9f03bd51a1f47d423e56ef768e440a99f3b61cb"
    sha256 cellar: :any_skip_relocation, ventura:        "b7b14713c50fe3e99205939ca50106743c51e47d028bf6df46a255707b345041"
    sha256 cellar: :any_skip_relocation, monterey:       "6498209ed6dfea3e1c1a3521aa77adbb54e1528393e66dd546c1c78cfd196350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "904a14b9331d7c94347f87a32042b7e8a9c6f482c0a73551bc3185786685f72c"
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