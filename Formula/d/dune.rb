class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://ghfast.top/https://github.com/ocaml/dune/releases/download/3.20.0/dune-3.20.0.tbz"
  sha256 "767999da81e528484139ecfe927288ffe521ac2467462a40d6a760ed789ba086"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e54fcbc06c84cfebbecaf1f4bce0c1a59373026eee3b0d570bbf6268aebf264f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6127c563ad285f0dd7db117eb0c1409257e4105cb3bc8b271860794631e8cad2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "890e56a0c6550ad08492dcd5b65903948edc4a0bf83f25cfd034915f1812b757"
    sha256 cellar: :any_skip_relocation, sonoma:        "923b74373776e1f1488f89b38a6f48f0ac4f0569c867b409a0ae6b702abfaffd"
    sha256 cellar: :any_skip_relocation, ventura:       "c8d8de120aa0834f800821da5efa598c8fdaf7424a2c6e935faac2ac055909be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f19bc6d2243ad0672bc552df75ea5110bc42d83fd7c94824aba99f0d53a37fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ea666cd01bac7fd01200293198c9442855b20c3bf86b98fadbb765643bbb000"
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