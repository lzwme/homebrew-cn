class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://ghproxy.com/https://github.com/libgit2/libgit2/archive/v1.6.3.tar.gz"
  sha256 "a8e2a09835eabb24ace2fd597a78af182e1e199a894e99a90e4c87c849fcd9c4"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "822b367763f3da96902d2dc3d0097dbb00721dec9c3d9143ee4c4ebc046cd690"
    sha256 cellar: :any,                 arm64_monterey: "e2e40a225387d5705b0a017efd74a92d0e6536d2e5ff631b7625984b10dd5a75"
    sha256 cellar: :any,                 arm64_big_sur:  "948c5bd2caa8d39db60937a6bba656629e362beac39f957af0f46c5fb666f528"
    sha256 cellar: :any,                 ventura:        "39185b59eb520c1d68343a09ab507d843835fdcaa03c70ca189ef72bad27bb84"
    sha256 cellar: :any,                 monterey:       "c55a6fdf7dbbd9b56b2a66d4e9848fa3dddf25ff1158c95bb61e8392f80b3804"
    sha256 cellar: :any,                 big_sur:        "ef9cc3534fd8c9f7f82d4e8b11cbfe015e8ab597f75c4ea1a3f796f4115bd8ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "332bac038ef61bcdd8a6810cb379b3711f624fad5120e84abd908a8eeae08b94"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = %w[-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DUSE_SSH=ON]

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libgit2.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <git2.h>
      #include <assert.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        assert(options & GIT_FEATURE_SSH);
        return 0;
      }
    EOS
    libssh2 = Formula["libssh2"]
    flags = %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end