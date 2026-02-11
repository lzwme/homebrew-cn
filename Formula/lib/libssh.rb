class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.12/libssh-0.12.0.tar.xz"
  sha256 "1a6af424d8327e5eedef4e5fe7f5b924226dd617ac9f3de80f217d82a36a7121"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92e32c71ce8d43597bd5305745825e1b53c21bf851092c4072c484020d006f6d"
    sha256 cellar: :any,                 arm64_sequoia: "36c6234407a28413a0c389a232d272a584be9e0f273c6f05db42d2bb53c94d64"
    sha256 cellar: :any,                 arm64_sonoma:  "43f63a8689e7972bbf5568e99388ed60fe693c85bad7940137bdf6d60d896108"
    sha256 cellar: :any,                 sonoma:        "aa04743019e28b780925d68a4c6184adc4a71fae84106d5758bcaa8ac79617be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3ca4ba4e6f214929a60056a2875a24e544bfc0ee7f176004557b262ff3df146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55f4bffc8eae46c1636667035bdaf0b4226c5069c436c509b1b575ea37efe216"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    args = %w[
      -DBUILD_STATIC_LIB=ON
      -DWITH_SYMBOL_VERSIONING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    lib.install "build/src/libssh.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libssh/libssh.h>
      #include <stdlib.h>

      int main() {
        ssh_session my_ssh_session = ssh_new();
        if (my_ssh_session == NULL)
          exit(-1);
        ssh_free(my_ssh_session);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lssh"
    system "./test"
  end
end