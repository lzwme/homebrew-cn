class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https:libgit2.github.com"
  url "https:github.comlibgit2libgit2archiverefstagsv1.8.4.tar.gz"
  sha256 "49d0fc50ab931816f6bfc1ac68f8d74b760450eebdb5374e803ee36550f26774"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https:github.comlibgit2libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af706565ac2a03d3d765ed233aa4247dad3fb66d95b81762dca6eda04227c015"
    sha256 cellar: :any,                 arm64_sonoma:  "771f2b1ccc5fb1b4398570f8d69b54f0d941c92a4703b48e84fcfac81256c720"
    sha256 cellar: :any,                 arm64_ventura: "dd50ae6085310761b73171d1f225728227d3de9fc763d1f4ed999ee6bee5a4c3"
    sha256 cellar: :any,                 sonoma:        "1e2d125e49b5b7a55e1e1de88e5597451fee74e989b8f703bb84522b2c778723"
    sha256 cellar: :any,                 ventura:       "2d324aaded04a396af21dd0daec49fe455d5081e2ed911330f9281eaaee46c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e33599ab70f4c70f137c61cf4664b5416ca7e75453310c70ead985530a65b8dc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    args = %w[-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DUSE_SSH=ON]

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-staticlibgit2.a"
  end

  test do
    (testpath"test.c").write <<~C
      #include <git2.h>
      #include <assert.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        assert(options & GIT_FEATURE_SSH);
        return 0;
      }
    C
    libssh2 = Formula["libssh2"]
    flags = %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system ".test"
  end
end