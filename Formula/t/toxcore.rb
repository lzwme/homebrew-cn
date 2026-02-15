class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  license "GPL-3.0-or-later"
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/TokTok/c-toxcore/releases/download/v0.2.22/c-toxcore-v0.2.22.tar.xz"
    sha256 "b2599d62181d8c0d5f5f86012ed7bc4be9eb540f2d7a399ec96308eb9870f58e"

    # Backport fix for size_t usage
    patch do
      url "https://github.com/TokTok/c-toxcore/commit/40ce0bce665e5589838db8444437957f8e3b83a3.patch?full_index=1"
      sha256 "65200822334addcbcca431910e5c5076cd0d01622a019044f9399f95be67edeb"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ae8ce1025bc93c45c9fd531552147ce86580a4f8b03a366c1ccb5a1f5f3ae34"
    sha256 cellar: :any,                 arm64_sequoia: "760b5ee2a711ec1cb258436350a2d4072260de47a05978ba69799b87d3c27271"
    sha256 cellar: :any,                 arm64_sonoma:  "339bfd9374b677b7fe32bf74bce1775287cc7b6d87fc93f7a3a2931a2879fe98"
    sha256 cellar: :any,                 sonoma:        "1a508f1d508f42d6e1bc95133d2b5835ba3a8011dd89b6dcf7cb90cf87c400f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dba3fafd018408183b85fc61d824289c0f539261e1fff6c1c5d9552140a4c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "097414b1cbe53b9c858deb008efeba328f4fc30b216ce357f8f59773bebf7502"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
    (testpath/"test.c").write <<~C
      #include <tox/tox.h>
      int main() {
        TOX_ERR_NEW err_new;
        Tox *tox = tox_new(NULL, &err_new);
        if (err_new != TOX_ERR_NEW_OK) {
          return 1;
        }
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/toxcore", "-L#{lib}", "-ltoxcore"
    system "./test"
  end
end