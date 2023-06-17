class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://ghproxy.com/https://github.com/ocaml/dune/releases/download/3.8.2/dune-3.8.2.tbz"
  sha256 "5a6ec790128616b6b46616427fa9c8f2ba0d6ef5a405bf8fdbc6f82dc0d935fd"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "350ff2631535f0b41df31392c3b6cb4b5ad8744b4db75ed77526e4d5647a5b85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08e0e55e41aa7bb9f479a1035942328d12020ae572606321b28b548728896a5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a791da1b83b3dba3b275d7e72bb83f829482f25a891f8b1e7199f6b3ab6c96c"
    sha256 cellar: :any_skip_relocation, ventura:        "392d51e9672d1c587bedaed1f8b5f4c1d1ced97fcc083d4c59a66699e169dfd1"
    sha256 cellar: :any_skip_relocation, monterey:       "3cf3fdb9f6ca5d498f123b59f8bd64c80b3c21fa2c7629127f5da13649f8a8b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "155641de460598a46848448a51d81647dd0014c16dc0595899bcef4e912923a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ca0e26f93417319eebeaafc0dff75fdbb8616e764b247fe3a55d711b27ced76"
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