class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghfast.top/https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.24.tar.gz"
  sha256 "72a160498f97565d694c740901fbfa320f6fad7db4a8e946ccd5352c9472c556"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7619b5a753bf6902f1247443806a3b6007578f0dd9a0ab235abdbbc251bcbed2"
    sha256 cellar: :any,                 arm64_sonoma:  "1800c75084f4e2bdd6f026c8aa1722b59b6c640ac648413d0f5d7a05cc146b2c"
    sha256 cellar: :any,                 arm64_ventura: "23e4a9ffef073738cb2d408c07089876fae359f3cc1fdc5cd26a3101fd2ffb21"
    sha256 cellar: :any,                 sonoma:        "85727059fbbbdf32f2e33acccd755f8a50493d57fc1ecd61adb5073f2c9b22b6"
    sha256 cellar: :any,                 ventura:       "8b9c68d4580531a7f6ea409f92409b7eaa4ff76ff5d75dd634e5ff6cb8ef877e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e624ea465e516fd57c77cc29af934523219fc540d58e7f79298410a7bf1c71ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "516b15b2fbb765e354394ceb3f8760ef7932bc8a06047e922e51311b0c085891"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end