class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://ghproxy.com/https://github.com/ocaml/dune/releases/download/3.9.2/dune-3.9.2.tbz"
  sha256 "4f3acbd45d3dcdbbbda891372f43f056942b6b96ed977ec5281ba9a875134adf"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02a3c08fe96671295644127ac2b27b9060084ed71d776be25377f61203c468cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87e0f68db840fc3ac58806ebe9555a48f8ae45239b9f7df7c316d8a169d66909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3f9089fa4e58b88d8cf1c8f44fe6cfe069ab1ea8d0418d5066d6146137b1eac"
    sha256 cellar: :any_skip_relocation, ventura:        "e082b4567b393a651d9785e8c7824b7bedddda1144bc66ff2eb1ceb01cfa2c71"
    sha256 cellar: :any_skip_relocation, monterey:       "eafbfbfcc93003e7ae0ffd93348a65731b6a8eba1aa7e6cd857ef6ca27d43a60"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdfd0e113e5edcf4b29e50acdc8c392bfdf72af5c7082322cdb14c5533d39bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0708c22baf3c6eed5a7686bbd8c5da7ef4692b3e664ce9a13a514175a579054"
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