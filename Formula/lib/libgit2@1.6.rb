class Libgit2AT16 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https:libgit2.github.com"
  url "https:github.comlibgit2libgit2archiverefstagsv1.6.5.tar.gz"
  sha256 "0f09dd49e409913c94df00eeb5b54f8b597905071b454c7f614f8c6e1ddb8d75"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https:github.comlibgit2libgit2.git", branch: "maintv1.6"

  livecheck do
    url :stable
    regex(v?(1\.6(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "83f4ee26d02fbfda076cdebe727390dd4db92ec8cb3791115212f43d6047eeed"
    sha256 cellar: :any,                 arm64_ventura:  "fdd0c3045a62a5abd4668b43bb384e4586cb79520bfc89c53f96af6cbf86b362"
    sha256 cellar: :any,                 arm64_monterey: "735c54cafdf705104f516c73f808c7b58e746402c5e5fd7d9de991b26b0ee3a1"
    sha256 cellar: :any,                 sonoma:         "6ab0d20d176740e61ef21cf5e583ca1642953d74c278af0668a761f646d10b3b"
    sha256 cellar: :any,                 ventura:        "331e0768ad6bb277c1d84901c83e851e8ab5af7a791a61ac8b962cb938df20c3"
    sha256 cellar: :any,                 monterey:       "d4ac0449a3342561c75ffa40d92cdc4e3fd4bcef7deff58827e59b584149bd65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bccdefbeb5fcbf1ad61fbd89ea1ac463a4b66421287723d72386d5f6ed81cf50"
  end

  keg_only :versioned_formula

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
    (testpath"test.c").write <<~EOS
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
    system ".test"
  end
end