class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https:coccinelle.gitlabpages.inria.frwebsite"
  url "https:github.comcoccinellecoccinelle.git",
      tag:      "1.3.0",
      revision: "e1906ad639c5eeeba2521639998eafadf989b0ac"
  license "GPL-2.0-only"
  head "https:github.comcoccinellecoccinelle.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "5c683addbcf76534570866b19e50f66e5801a21964b83fc0df6be2317908be8e"
    sha256 arm64_sonoma:  "dc6683b280f7bacbadeb189df0205552008bd59e731c707a6ec8d67bb72a2dcd"
    sha256 arm64_ventura: "bf402cf474f0e155012f1417285adbd8614e1e739d54fdf9615d3f064488e1fd"
    sha256 sonoma:        "397ca9ef368f02305f1c3179ea3776c3c2aa7ad882d767b6dfa096e30b5c172b"
    sha256 ventura:       "e29c54ac0afe552d55999560e56f5fb37a8490a1b6133bcb652cc7afc752b406"
    sha256 x86_64_linux:  "a21ea74ebf3431b79f8c242a6594995371f1123e8a4aff4fed5c9cecd72967c9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hevea" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => :build
  depends_on "ocaml"
  depends_on "pcre"

  uses_from_macos "unzip" => :build

  def install
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "exec", "--", "opam", "install", ".", "--deps-only", "-y", "--no-depexts"
      system ".autogen"
      system "opam", "exec", "--", ".configure", "--disable-silent-rules",
                                                  "--enable-ocaml",
                                                  "--enable-opt",
                                                  "--without-pdflatex",
                                                  "--with-bash-completion=#{bash_completion}",
                                                  *std_configure_args
      ENV.deparallelize
      system "opam", "exec", "--", "make"
      system "make", "install"
    end

    pkgshare.install "demossimple.cocci", "demossimple.c"
  end

  test do
    system bin"spatch", "-sp_file", "#{pkgshare}simple.cocci", "#{pkgshare}simple.c", "-o", "new_simple.c"
    expected = <<~EOS
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    EOS

    assert_equal expected, (testpath"new_simple.c").read
  end
end