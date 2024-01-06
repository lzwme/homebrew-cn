class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https:dune.build"
  url "https:github.comocamldunereleasesdownload3.12.2dune-3.12.2.tbz"
  sha256 "e8aa5f01fee83efac8733df0bec3e23aaecdb4524bc58b8065cd18cc07295fb3"
  license "MIT"
  head "https:github.comocamldune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2edc45c1dc20ed0a3b8f892453ac58a8bea9542d633397df4e3ca6ae31e12582"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d22fb5eec15ed90cb5adcc0d170a1c926559fddfe215a6de5596288e983720d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0037cc1d08a0bfa9f1c95f440acf0dd3ef6cd8d1ad5e2686a22b7b74b5af98b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8bf8c765cddc19da5fef190dcf7faa94a82b19b193e18f824ed5d2044133625"
    sha256 cellar: :any_skip_relocation, ventura:        "ffc505be721c6bc449bd0ea9c50086ef355daa2fea2dfc0d98c9296b10180d95"
    sha256 cellar: :any_skip_relocation, monterey:       "0edc466c6274f0ca8412e63adf06a84cd6a501dedf79a976fc7a49cdb2254476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42a0f35a8ddb7676c9a1dace60ca4a90df5b95077ec0d1c8819e534d9134c40c"
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