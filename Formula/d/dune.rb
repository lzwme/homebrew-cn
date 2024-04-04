class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https:dune.build"
  url "https:github.comocamldunereleasesdownload3.15.0dune-3.15.0.tbz"
  sha256 "b5c3d10f6f6048bfaf56fc4f0942d56381b55af4287caf8251487d4c4e7920d7"
  license "MIT"
  head "https:github.comocamldune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38853087495730964601f2898660580b2a0f50bfc219ab345f85dc2280a3ba6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d152625801466ebfc95dc0097975e762dfad4d03a937ed68ab0fa8df88ecb072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2915442e01658e4bd3bcc948a26f4d91b056c6d833767d2632609e9cccb2b4c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5206510eb14068a410c77b104b760f3afdae7b5822d56a37c15b9bd9b04cca95"
    sha256 cellar: :any_skip_relocation, ventura:        "a0c1682e6cf86788b4ac72b3d8d98740f06339d6735da7f3fa0193d0739bc02e"
    sha256 cellar: :any_skip_relocation, monterey:       "2fe2dfc7e107d528751d1258a90341f16427aa695744f19be1766a134793e9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "355334ce9827b893b82e185e169d2a3de86e2be0827a434e60f4fd7ee740ba0f"
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