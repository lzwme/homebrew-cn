class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://ghproxy.com/https://github.com/ocaml/dune/releases/download/3.9.1/dune-3.9.1.tbz"
  sha256 "f0c3ce49f36c733b8aee72611f107cf06de6bc423be7262aab1bb3f03c05a878"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d49fc9f90f049822054d9434f697f2d89d673c02c723d16a10d60b0be337473"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40db1f37b511c7d60b865cbf6a45362e6e32060c0506d9f7529af34c14c7e999"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4abcfcd0bdc9ad45c85a86a8c70891346beb6b7f5c730fa0e3ceaef584de576"
    sha256 cellar: :any_skip_relocation, ventura:        "ae2ce6ff33faa198db7954fb46397422ae548914b9d0714fa888ff759e6625e3"
    sha256 cellar: :any_skip_relocation, monterey:       "d3a78f95b037364ede9cd26709a19c37b6ccd11a617041efe401b303e5a21662"
    sha256 cellar: :any_skip_relocation, big_sur:        "16968c8e39abc3080ceb7d8fac27c49b856c9f3027136283d696894f44998667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09a6d861c5ba5aff3b006aa103aa9192a7246c43c0ee1a161c8297393dae9285"
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