class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://ghproxy.com/https://github.com/frankosterfeld/qtkeychain/archive/v0.14.0.tar.gz"
  sha256 "ad78f2d9e0a5ee80f40cbaace4f55d11c2557bc6e930cf4a9479e39a7d78bb60"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b12487c050ee842949666c78e2661092d570be0a1ead216fab5a0efe285add7"
    sha256 cellar: :any,                 arm64_monterey: "e729e335235b0825e205fddc4b8e518989768e3f2d2df99110f64dcdb6d07afc"
    sha256 cellar: :any,                 arm64_big_sur:  "cf39f2492dcbddfb9320fb7bd2afd0ae8597d9cd88bfc5ff4bef7d83c36fbba0"
    sha256 cellar: :any,                 ventura:        "22a8c1a34d6f30f0437ec4a9028c9fd2012e94703aff195aac15ca8c80087d93"
    sha256 cellar: :any,                 monterey:       "f929c0075dcff1f254c8ec0741f64c6ad365bc9cd3d5c62eb8e6c0a00dda50fc"
    sha256 cellar: :any,                 big_sur:        "211c4763b207c7b8382b2886c91bbb6169dd2abea3a01917c30c5747b0254e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d93ed2ed85362d0a225cf4ca2f20802907b8853e72d8a08eb9fe2e02b5b65f1"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  on_linux do
    depends_on "libsecret"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", "-DBUILD_TRANSLATIONS=OFF", "-DBUILD_WITH_QT6=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <qt6keychain/keychain.h>
      int main() {
        QKeychain::ReadPasswordJob job(QLatin1String(""));
        return 0;
      }
    EOS
    flags = ["-I#{Formula["qt"].opt_include}"]
    flags += if OS.mac?
      [
        "-F#{Formula["qt"].opt_lib}",
        "-framework", "QtCore"
      ]
    else
      [
        "-fPIC",
        "-L#{Formula["qt"].opt_lib}", "-lQt6Core",
        "-Wl,-rpath,#{Formula["qt"].opt_lib}",
        "-Wl,-rpath,#{lib}"
      ]
    end
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++17", "-I#{include}",
                    "-L#{lib}", "-lqt6keychain", *flags
    system "./test"
  end
end