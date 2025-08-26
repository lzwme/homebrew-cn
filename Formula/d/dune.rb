class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://ghfast.top/https://github.com/ocaml/dune/releases/download/3.20.1/dune-3.20.1.tbz"
  sha256 "f08e95de2828e891d68906e4430b5117032285207b5bc684fc5d45652eb30e0a"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa9788371ea4d0384b3ca3245053adde1133dae3cbfdeac01b1c101fcb92ac58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3d4659332642ed4bf0a44fe6f47eedb2404469e3fc159a8112a61cc1ff70c0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3885c13a37735c5a061317532f0323520471ae4a09a1e94025af74b6b688123b"
    sha256 cellar: :any_skip_relocation, sonoma:        "291776571e6884029552eaccaf6cd59f71a8db01bda41312084211c8a3b3d975"
    sha256 cellar: :any_skip_relocation, ventura:       "d8273d488e78636737389610b44fda42c4829e47e7f06468fd4bf6f136701812"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb250ff2ec914112ba0bac171373d7e419aa0bb607d4785d1fa30e00ba29f4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7097051be7346f46ae91f1ecbcc31b9c7339dabfb92ce055994a0fb304b3d0"
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