class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https://coccinelle.gitlabpages.inria.fr/website/"
  url "https://coccinelle.gitlabpages.inria.fr/website/distrib/coccinelle-1.3.3.tar.gz"
  sha256 "265dba12a71e5169d49af9a2d8c3c4b8e2cae4c451c918beb2587c33d6128e3d"
  license "GPL-2.0-only"
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f8b9578bc876063cb9b3daaf4b70fb0b337a0e605c93627431f9d9492584581b"
    sha256 arm64_sequoia: "0b00c84268c699a160778051076c2842ad21e9be8424d04664a821bfb208b134"
    sha256 arm64_sonoma:  "f4e7a8a65dc80b462c7380bd7711516ba35165bbf065ed51691315f95a693953"
    sha256 arm64_linux:   "f8196a80afd37c776d5fa2398c076847a460d85b8e63375476d567fe857513a3"
    sha256 x86_64_linux:  "a2490d2f8c521fb7c60d1a3f281c3e76041ae8bda40b866cbd100205c8270262"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "menhir" => :build
  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build

  # Apply Fedora patch to allow stdcompat to build with ocaml 5.5.0.
  # When removing patch, also remove autoreconf and make autoconf/automake HEAD-only.
  patch do
    url "https://src.fedoraproject.org/rpms/ocaml-stdcompat/raw/03dbbd7cb60f48ac7785d15ed995a90734538a5c/f/ocaml-stdcompat-ocaml5.5.patch"
    sha256 "ba7970304d73ebe4d1e4c3f6589274c5f604a6124aa312740c8ccf56c7272bd2"
    directory "bundles/stdcompat/stdcompat-current"
    type :unofficial
    resolves "https://github.com/ocamllibs/stdcompat/pull/75"
  end

  def install
    # Remove unused bundled libraries
    rm_r(["bundles/menhirLib", "bundles/pcre2"])

    # Help find built libraries on macOS
    inreplace "bundles/pyml/Makefile", " LD_LIBRARY_PATH=", " DYLD_LIBRARY_PATH=" if OS.mac?

    # TODO: remove when patch is no longer needed
    cd "bundles/stdcompat/stdcompat-current" do
      system "autoreconf", "--force", "--install", "--verbose"
    end

    system "./autogen" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--disable-pcre-syntax", # needs EOL `pcre`
                          "--enable-ocaml",
                          "--enable-opt",
                          "--with-bash-completion=#{bash_completion}",
                          "--with-python=python3",
                          "--without-pdflatex",
                          *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"

    pkgshare.install "demos/simple.cocci", "demos/simple.c"
  end

  test do
    system bin/"spatch", "-sp_file", "#{pkgshare}/simple.cocci", "#{pkgshare}/simple.c", "-o", "new_simple.c"
    expected = <<~C
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    C

    assert_equal expected, (testpath/"new_simple.c").read
  end
end