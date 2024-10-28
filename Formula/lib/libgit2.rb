class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https:libgit2.github.com"
  url "https:github.comlibgit2libgit2archiverefstagsv1.8.3.tar.gz"
  sha256 "868810a5508d41dd7033d41bdc55312561f3f916d64f5b7be92bc1ff4dcae02a"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https:github.comlibgit2libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c4301f0b1ca9da9fbdfb6cbdc81f8861536430b27345c5b91b5d769e65bef1f"
    sha256 cellar: :any,                 arm64_sonoma:  "b1184ed75abe9d13a857009586b4c5cad527954b9d34c517187b65b637a403f7"
    sha256 cellar: :any,                 arm64_ventura: "221af531057d896d0c87777f80681a6f98a4538a8bacd837fe830cf286493fcd"
    sha256 cellar: :any,                 sonoma:        "5158fc1520cc16900600df3dd3de98ff9399985e4d268b28f08d4dd64449c30b"
    sha256 cellar: :any,                 ventura:       "5a8a55d88f7102da9b34bca4f1740f939aba56f20d731825427d2482177e9b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1efa723113d8eea3dccb1ef6cb92faf714d40a5026eb3d5d08f4ad15b2ea11d3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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