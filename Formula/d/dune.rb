class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https:dune.build"
  url "https:github.comocamldunereleasesdownload3.13.0dune-3.13.0.tbz"
  sha256 "f1801257e01c846bd71017ec5d4b2b75fd31b20a0d5979b933b37cc8453678de"
  license "MIT"
  head "https:github.comocamldune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b458649af1b6c01b71782ee3a7a2d065dc01586dc1cbf5a817f98be283a74f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "059f1ae53be074c9f7b2d64e7cfb917fa6dcd31c98fa4ae791099b7c9e3d3541"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22a10ae02e2cea62a1aa7aff708642bc72cd6878f391153ce6437e5bd15bfb6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a49030c6d638e63464b6f963f5cd18ae5f2043228092a321949710f2c7d66fd8"
    sha256 cellar: :any_skip_relocation, ventura:        "0201e4de84d2fbe1ef22209d50ce1667a3a19ddb63f677a4293c4dde4e75c90f"
    sha256 cellar: :any_skip_relocation, monterey:       "a5479ae9a52df8cebdcc7a54ab3206c459de195ec243048697f7ddca399c5ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "386fe347f81df10c5d628bade06530445158c876ed9fedb8435cdf8528cb8c40"
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