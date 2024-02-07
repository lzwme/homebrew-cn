class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https:dune.build"
  url "https:github.comocamldunereleasesdownload3.13.1dune-3.13.1.tbz"
  sha256 "2fe0af1b4cf98649c7555b555d9f4f81d5ded87718a89df4988e214a56c8a916"
  license "MIT"
  head "https:github.comocamldune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6744c18b719cd3e29cb2c55c54581f79fef565a609319f00b31ea060c987093f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "700b9d96ad444501392fb0d7c9dbe7a675004257c4cf696a5d4298b459315863"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d035fcfaaf8d14e6986f8ac05d0967fdf16a93115ee27181f5aa619b2689028"
    sha256 cellar: :any_skip_relocation, sonoma:         "2753a9ca54b487275820af0c629bd56c2420796a211fad0e4c2e889fd3e0b131"
    sha256 cellar: :any_skip_relocation, ventura:        "865593e948483024b35a90583818f477352ea4a2c1a6d9c53f110e6c5fe99022"
    sha256 cellar: :any_skip_relocation, monterey:       "4d14292341cf90c56270f7b09dd0d82b61c44abbd9e9c2f88c82949349e96f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9abfac2ded98a9e7f5dbbc9734ffa249e695ccf458ff7731f9d93ce20a2819b4"
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