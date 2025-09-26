class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://ghfast.top/https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.12.7.tar.gz"
  sha256 "9278ab7a59e53b4e48c38c4655d6df53d86dacd14b6b6be5001937fef798ae9a"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "2b6141b94c8935abd0308a40b9c1ac10675d281ee6c182b040e8ac1fcd5830e4"
    sha256 arm64_sequoia: "a479aad5c21c9a81b9cfebc504496bfe013f418ea863aa5355bfd1abea747f63"
    sha256 arm64_sonoma:  "516a9a53c4e49fe44ff272561e66158b0713b372a0c0571d904d4bec89b8b338"
    sha256 sonoma:        "186f915e6bb5f396e85b7f0c3672e3f6f26315ffb0c228a4981e7b803efcc453"
    sha256 arm64_linux:   "0a725802760820101380cd46a5a7db4c3dead2b49761ff5c703a2a36954283d9"
    sha256 x86_64_linux:  "08c745621a3da668b533e9acc802d2d82f1c12378006af7590dbfe348cd2b6df"
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