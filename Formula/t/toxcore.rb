class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https:tox.chat"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https:github.comTokTokc-toxcorereleasesdownloadv0.2.19c-toxcore-0.2.19.tar.gz"
  sha256 "8b418f6470db085cf59a9915685613556556df2bf427148f1814b7b118628594"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comTokTokc-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8115a1b7420fe04e3317b34b23089616c585c58741bf3248e3b2004d09b49a74"
    sha256 cellar: :any,                 arm64_sonoma:  "4447d4c8882c0f794fd933d3b771306acf67e8f3638ae7125f08b5bda5c1851d"
    sha256 cellar: :any,                 arm64_ventura: "e4bb9510c529cc113e795c9063c331976f7bdd1dcdb8e8285150b4925f877406"
    sha256 cellar: :any,                 sonoma:        "4f9b719b1748fb5e54996a487c301857d5d40c2104a41a2d60d86c6b1eb40abc"
    sha256 cellar: :any,                 ventura:       "5ce4ae2f7d9270d9912b2fb3a8a332626b21bae85e73b816d50c43cb41bb1b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28260047bfcfeb5441f1b73d8f58eaad3d1609bc0660a4b54e79467ca32771a4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libconfig"
  depends_on "libsodium"
  depends_on "libvpx"
  depends_on "opus"

  def install
    system "cmake", "-S", ".", "-B", "_build", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <toxtox.h>
      int main() {
        TOX_ERR_NEW err_new;
        Tox *tox = tox_new(NULL, &err_new);
        if (err_new != TOX_ERR_NEW_OK) {
           return 1;
        }
        return 0;
      }
    C
    system ENV.cc, "-I#{include}toxcore", testpath"test.c",
                   "-L#{lib}", "-ltoxcore", "-o", "test"
    system ".test"
  end
end