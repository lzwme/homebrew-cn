class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://ghproxy.com/https://github.com/ocaml/dune/releases/download/3.12.0/dune-3.12.0.tbz"
  sha256 "85515e64b6ffb99faf1eaabde9153577c1b0a5e721d319d43ef069a9d2ab3c3b"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc55cd2c6ea37e236bdceb2026f69029e7f44abe7ca6bd18f1300afb7183eb95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7573890362a06d4be1acd83108716cb7ae687db72bdd49ddb6d7bdce5a602801"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71e377ff63fc08f68a4b7cfd9fcf78b789111543e031b7aae3894a842fd3dc5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8474a28e33b30ab7b0cb29b4119eb1cf95a8a208e66a3366ad76b3699ce0d0b"
    sha256 cellar: :any_skip_relocation, ventura:        "6203642b230fb50dec6bdcdee0399e0ecb644bd2cc7adcd069f4b1e266b31702"
    sha256 cellar: :any_skip_relocation, monterey:       "ce2275851b436f357f03eb0a5cbc54a05882053dc8c73679036b63a8e9e4a55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01183a949a3b648e07d5f9259a27ba8156cf9c6295070fda837c91e291aeda1"
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