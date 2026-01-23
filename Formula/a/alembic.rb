class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://www.alembic.io/"
  url "https://ghfast.top/https://github.com/alembic/alembic/archive/refs/tags/1.8.10.tar.gz"
  sha256 "06c9172faf29e9fdebb7be99621ca18b32b474f8e481238a159c87d16b298553"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53a58c02e473c4a64d67e434cecb6469a03ff931fb0b69e465380306da093e81"
    sha256 cellar: :any,                 arm64_sequoia: "6429addd2094899db26862db4ebadf0b92c8aa07537d5182420adbefa6053578"
    sha256 cellar: :any,                 arm64_sonoma:  "740f3d0132a5b0e988d553fdae078656501e143d5d5bd555f4bfcb80ecbb7ada"
    sha256 cellar: :any,                 sonoma:        "50cacfbe5f7551058ae1aa76a4e246fd683ceaf49d82966db38b908374aa677e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeae8522fb0f0bbc0197b917fddef3686f871ef9537a6633841734fcc67679cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c0ebd5e4143cfa6df3c482fd4226c6e2eb87ba331d194a37dafc1945f9f261a"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "imath"

  uses_from_macos "zlib"

  def install
    args = %w[
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DUSE_HDF5=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "prman/Tests/testdata/cube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}/abcls #{pkgshare}/cube.abc")
  end
end