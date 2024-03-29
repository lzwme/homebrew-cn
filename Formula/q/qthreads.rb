class Qthreads < Formula
  desc "Lightweight locality-aware user-level threading runtime"
  homepage "https:www.sandia.govqthreads"
  url "https:github.comsandialabsqthreadsarchiverefstags1.19.tar.gz"
  sha256 "2790382991c0755d752354b189aa019076c80ebed7f4c5c045d14bd57c9eb7ac"
  license "BSD-3-Clause"
  head "https:github.comsandialabsqthreads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3e6aa2e908bdd99012e105a838839c1d3f5e42b6ffb6d2418331317412a5a20b"
    sha256 cellar: :any,                 arm64_ventura:  "33ab2dcf7b44c16fd51b202fcf036284c42b8b43d227e253c8124db7651d04f8"
    sha256 cellar: :any,                 arm64_monterey: "b56492f664bce061890d3ea8bce840759225fa6f3be04ae8a7c8dc13c6ff84f7"
    sha256 cellar: :any,                 arm64_big_sur:  "d644d6ce04ded6dc63ad7155bf4bc72ea29ffbdb9e58295ef2fb3d6860b91a9a"
    sha256 cellar: :any,                 sonoma:         "5fc777c6d6e5f0a292b76d93b659c40a4de2251bf1b79ad0860699002e4bd2f5"
    sha256 cellar: :any,                 ventura:        "811a8680f91d8d9a2e28a0fb3a65c6b0ba8af40e6a5c7ff326f91b95553ae0c7"
    sha256 cellar: :any,                 monterey:       "0b17b1bcf5c89afc9ec761261f34689dc2d40e0eacfb7ab11c28debc7444ac77"
    sha256 cellar: :any,                 big_sur:        "b28f76f53caeeff2a109e45c9f1f846f7248ab6939db37e4aaef01745860bb85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0f6d389a938d52561df8bafae07584d964af38e587f824a9c7f32e5d4f43462"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system ".autogen.sh"
    system ".configure", "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
    pkgshare.install "userguideexamples"
    doc.install "userguide"
  end

  test do
    system ENV.cc, pkgshare"exampleshello_world.c", "-o", "hello", "-I#{include}", "-L#{lib}", "-lqthread"
    assert_equal "Hello, world!", shell_output(".hello").chomp
  end
end