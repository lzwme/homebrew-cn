class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://ghproxy.com/https://github.com/evaleev/libint/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "f7525937a12ea65937ccbb74280a2571cc79a8ae6ef04b900bd0baad49d50c73"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "12a6d64becba1a32d90a56f74458d152c2f53f8467509467c6e227fc57762da2"
    sha256 cellar: :any,                 arm64_ventura:  "5b32428db5a39ea48ff2db5f4f2eea740b23d383e42086cbfa2e6d57d9c0e59f"
    sha256 cellar: :any,                 arm64_monterey: "69c717591419efbdd2c68bd55593aca05191a3de47cdafdbca5fd0327c044250"
    sha256 cellar: :any,                 sonoma:         "e34e062870b467974b263b628303c904da8353557220482f4310fce283881f63"
    sha256 cellar: :any,                 ventura:        "d452b472e51f6cdbe2f527a297c90b53fefd19021a311cc0c59f6cefafb09b42"
    sha256 cellar: :any,                 monterey:       "80a76a71b789ba203fcb4a89056e42e737903641f9a42bdb9788fe1a6cdd07d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7e16cccb8d69159f600f1db5d90a120156646459a56729463eb03094a25f2c7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "mpfr"

  def install
    system "glibtoolize", "--install", "--force"
    system "./autogen.sh"
    system "./configure", "--enable-shared", "--disable-static", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "tests/hartree-fock/hartree-fock.cc"
    pkgshare.install "tests/hartree-fock/h2o.xyz"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"hartree-fock.cc",
      *shell_output("pkg-config --cflags --libs libint2").chomp.split,
      "-I#{Formula["eigen"].opt_include}/eigen3",
      "-o", "hartree-fock"
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end