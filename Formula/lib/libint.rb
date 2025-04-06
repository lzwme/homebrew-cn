class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https:github.comevaleevlibint"
  url "https:github.comevaleevlibintarchiverefstagsv2.10.0.tar.gz"
  sha256 "9a8a9197a6f17a64c993b230b722f1acde95b23c6076e9c10b523144f2d657ab"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c8c77b247c4a2f47e8d02375fcfdbe30c617f57721746df541be576518195138"
    sha256 cellar: :any,                 arm64_sonoma:  "b5c622122f486a6861ba1cf65cdbb9328e321cbe187dada048ec2a4a6cb224eb"
    sha256 cellar: :any,                 arm64_ventura: "2ea6700829f8cf71b9503d02455f10271e043b1a94849d7290be4888792b330b"
    sha256 cellar: :any,                 sonoma:        "fd1a4e6c2c9b4d9256cad191ad8ef421dcf9e8423f2a9937e0f835258eeacd23"
    sha256 cellar: :any,                 ventura:       "8876e5e9c586c3d886a5604c15e310cbec5316e15a1b261ec1b0d0dbbd0ac75e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84cff3ceb635022da103fbcb9617fe8471afff5b2e0300aa7cbe9bd650caa543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21ea42faf15d2e97b7d07fe6ac50c508118d8d61b8bc37bd3f8024f1cf64bd32"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "mpfr"

  def install
    system "glibtoolize", "--install", "--force"
    system ".autogen.sh"
    system ".configure", "--enable-shared", "--disable-static", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "testshartree-fockhartree-fock.cc"
    pkgshare.install "testshartree-fockh2o.xyz"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare"hartree-fock.cc", "-o", "hartree-fock",
                    "-I#{Formula["eigen"].opt_include}eigen3",
                    *shell_output("pkgconf --cflags --libs libint2").chomp.split
    system ".hartree-fock", pkgshare"h2o.xyz"
  end
end