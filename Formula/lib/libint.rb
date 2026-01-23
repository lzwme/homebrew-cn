class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://ghfast.top/https://github.com/evaleev/libint/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "732988a1ea95eb4eae91bcb2b2a718d95dc5caca41533746fc4111532d55ae74"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7753ab7a751682e82933f613c3e8f0dbed020c187f4033bf7883f43c13fb9906"
    sha256 cellar: :any,                 arm64_sequoia: "b35ebbd19dd5eceb28e1ea684489c72d038796b5a3bc8bc73df07807f9b38ae7"
    sha256 cellar: :any,                 arm64_sonoma:  "493aff546d60aeb2d28c27328d5f097152743d26d8545628ed7232c5a9b3e2ec"
    sha256 cellar: :any,                 sonoma:        "7dcbe9fe6ddaca8d21fd647012357711aecae571726fc34e8b42285b2dbc87a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05a3e7fc3a2c80b48ebec6c5a4a00d9e66aa6657a251b7c9dd7cab6377cacfd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a63c3942366b5bef4c40b335ffb6cea146836af7db0aeb2a0aaf9537666780f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "mpfr"

  def install
    args = %w[
      --enable-shared
      --disable-static
      --enable-eri=1
      --enable-eri2=1
      --enable-eri3=1
    ]
    system "glibtoolize", "--install", "--force"
    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "tests/hartree-fock/hartree-fock.cc"
    pkgshare.install "tests/hartree-fock/h2o.xyz"
  end

  test do
    system ENV.cxx, "-std=c++14", pkgshare/"hartree-fock.cc", "-o", "hartree-fock",
                    "-I#{Formula["eigen"].opt_include}/eigen3",
                    *shell_output("pkgconf --cflags --libs libint2").chomp.split
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end