class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https:dune.build"
  url "https:github.comocamldunereleasesdownload3.12.1dune-3.12.1.tbz"
  sha256 "b9fd6560879f9d340ae8a87c967b0d2bcd3c4120cffcd9fb661f325078f74f6f"
  license "MIT"
  head "https:github.comocamldune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39e62a9ee02586660d3369fbb79406052b1463762dcc31c5ef5ef99ad3cb39e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1330b818a62410c8c28ee8ccf9f4582af22dd6d2d05c40a588b1e99990e35472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24c2dbca14efacac7a6c6aac083b6d1f677203b231d61aa20991b51f28f51222"
    sha256 cellar: :any_skip_relocation, sonoma:         "e015813bb52ad3eeaf5f5a0854655d82d1ba062680d39e14d4dd3b0ed0bb4a97"
    sha256 cellar: :any_skip_relocation, ventura:        "9185a03ae6a130f0d782563d96120d2e5526b89274f9d948d7dc1dee2134cfe4"
    sha256 cellar: :any_skip_relocation, monterey:       "b95f8e1802e1e148f2bb9f70f4aca5d343c7b0f4f11da8364b6ff149904cbe95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34939d32874016d9022ddecd4e20e100a549192f1af0ff6f2547ecacc63b864e"
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