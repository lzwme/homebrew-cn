class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https:coccinelle.gitlabpages.inria.frwebsite"
  url "https:github.comcoccinellecoccinelle.git",
      tag:      "1.3",
      revision: "e1906ad639c5eeeba2521639998eafadf989b0ac"
  license "GPL-2.0-only"
  head "https:github.comcoccinellecoccinelle.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "1db1e024f36804e14957b72edb458ff7bd5bab0755cb1553504f541f689ab060"
    sha256 arm64_sonoma:  "ccd9cb739d645186dbe3eaebfc09ddea35da8c682aeab2b8e573be6165c5a85a"
    sha256 arm64_ventura: "6e5071f3ddff0440f41df5eb5ff58b7eee288ca9688d3c8f2716ec7eb0c71567"
    sha256 sonoma:        "8eb2aec611913038f6100d61b04f46e759f26230ca50fc9dffc20ea845cb6c07"
    sha256 ventura:       "2f0d9450cf4b20ca59ca5c2f584c1c27021707097859ea3c83878651532c04af"
    sha256 x86_64_linux:  "62995387a9619d0365d4b67945054b695c2b7acec29d0d449c522dad27816acd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hevea" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
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
      system "opam", "exec", "--", ".configure", *std_configure_args,
                                                  "--disable-silent-rules",
                                                  "--enable-ocaml",
                                                  "--enable-opt",
                                                  "--without-pdflatex",
                                                  "--with-bash-completion=#{bash_completion}"
      ENV.deparallelize
      system "opam", "exec", "--", "make"
      system "make", "install"
    end

    pkgshare.install "demossimple.cocci", "demossimple.c"
  end

  test do
    system bin"spatch", "-sp_file", "#{pkgshare}simple.cocci",
                            "#{pkgshare}simple.c", "-o", "new_simple.c"
    expected = <<~EOS
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    EOS

    assert_equal expected, (testpath"new_simple.c").read
  end
end