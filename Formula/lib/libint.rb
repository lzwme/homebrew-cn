class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https:github.comevaleevlibint"
  url "https:github.comevaleevlibintarchiverefstagsv2.10.1.tar.gz"
  sha256 "c3673d34a4b8533e946538c5b72387a6ea0336f7132bab57c42c9ad9a3915620"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ea8e66a5c054b26007d3e166170beab725a47d8b9d4c47aa0bf2a27ccbc4001"
    sha256 cellar: :any,                 arm64_sonoma:  "4123afafd919e3aed5e1ef46189677c48416a3726376a1728a80cf076a92b0bc"
    sha256 cellar: :any,                 arm64_ventura: "c15e313e38474e5ef811b9863e64efa21f4a9a598c8eaa5be119f50bf6e220fe"
    sha256 cellar: :any,                 sonoma:        "0088ad398ee2f3d805c322e6b106a11c3f290e69f3fcc3bbccd8e306a5cb9204"
    sha256 cellar: :any,                 ventura:       "62e97b039fa484bc865c2c52c3a9d0c1d605ad4467f54f7b71833c57b75a5f4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40e683f2d2cbdce091780a8b89cd919518887a3c81e554bfe30284d34e5a50f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b6638b0e77006a8b8144753be3a0f392ccb523fc9dd14dfe093003225216ced"
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