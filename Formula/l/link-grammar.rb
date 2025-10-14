class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://ghfast.top/https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.12.9.tar.gz"
  sha256 "a7ec01775173ab844a73e781477db7498295e80dbbf0fd9589d445d8d5ee754a"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "2d00a7ce749e8d68ff5392c28e84ad1f00972edd77e09d8a6be2311a76ff2f53"
    sha256 arm64_sequoia: "b0eff50209510a8dbf27fb26d101a42c6293accd2cde0274ac40163f2802dda2"
    sha256 arm64_sonoma:  "84fe202fae2ca015878ab5554b43b7c33fda7ee5be7de5be25875010d202dd4e"
    sha256 sonoma:        "422e1905a2c3c8884c888447d2267b7036c34e637e799f242ff8d1e07dfeaa77"
    sha256 arm64_linux:   "5ab11bffc0d7f671377907e32e6c02291da3c90a114e9033dd2945495135fd9b"
    sha256 x86_64_linux:  "9b7cf86a9bd80cd489503014d7e05896961d1b6b793656b00f0a206e8db74061"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "swig" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "libedit"
  uses_from_macos "sqlite"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am", "$(PYTHON_LDFLAGS) -module -no-undefined",
                                             "$(PYTHON_LDFLAGS) -module"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-regexlib=c", *std_configure_args

    # Work around error due to install using detected path inside Python formula.
    # install: .../site-packages/linkgrammar.pth: Operation not permitted
    site_packages = prefix/Language::Python.site_packages("python3.13")
    system "make", "install", "pythondir=#{site_packages}",
                              "pyexecdir=#{site_packages}"
  end

  test do
    system bin/"link-parser", "--version"
  end
end