class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.32.0.tar.xz"
  sha256 "d1e8699468e01d2a76abe402b4d5c60c5095335c92b259088f062bdd3b929ca1"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b5e48919d6497a953c99ecedd8ce72ec80f9272d3631b59206256b850e08a50e"
    sha256 cellar: :any,                 arm64_ventura:  "05c0e2b21e259796e0102164141050c88e4cac56d75d3d4336e2fd5125fd1728"
    sha256 cellar: :any,                 arm64_monterey: "e9ea4983a707da903618bde1fc9c460267087f35e11539c71812f94948afa960"
    sha256 cellar: :any,                 sonoma:         "b5b5958e2179ba27e00d538f48bedd3e27e97318ae745b822ae708e4f1cb1845"
    sha256 cellar: :any,                 ventura:        "b8396f1631a07cefb51687fbc2e2395e71c77e1fa26c515e53954822aaf1fbf9"
    sha256 cellar: :any,                 monterey:       "addf2f895c43975024482d8b353eaf773d7ae6600dfe3e27f4679c6aa9b938bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5443575e4353f90b3e3cc7985bf821be7c71de7f2390822c21366b670ecce1ee"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "-Dtests=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    rdf_syntax_ns = "http://www.w3.org/1999/02/22-rdf-syntax-ns"
    re = %r{(<#{Regexp.quote(rdf_syntax_ns)}#.*>\s+)?<http://example.org/List>\s+\.}
    assert_match re, pipe_output("#{bin}/serdi -", "() a <http://example.org/List> .")
  end
end