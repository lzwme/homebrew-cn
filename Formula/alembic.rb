class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://ghproxy.com/https://github.com/alembic/alembic/archive/1.8.5.tar.gz"
  sha256 "180a12f08d391cd89f021f279dbe3b5423b1db751a9898540c8059a45825c2e9"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "65c61ae643350f1650ec46f993bbdb2274aebc0244255ca61ab333988600477c"
    sha256 cellar: :any,                 arm64_monterey: "4329cf18add1c25e5f644c3a320f1c1225351997849babee871e6d0e1b7d3ce0"
    sha256 cellar: :any,                 arm64_big_sur:  "d2771244f164932b8f2179e5005ee66b70a8bd716983cf216a5f8ed19f219c28"
    sha256 cellar: :any,                 ventura:        "877b5b92f82f91b2f24beb7e90df3a948c2b378d5b6f59832b1bed2705563bc7"
    sha256 cellar: :any,                 monterey:       "31b3e429d4da1f9f368b446ecc7c1444b8fddd9ba7fa87a554146ef61993bcb1"
    sha256 cellar: :any,                 big_sur:        "3512b654aa6eb2396c19796d903422458c7f86d8ee857afb76abb8cc83d8a4b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eed637a411ef960d275d05237c079889ebf0240b38d30f6488a0f9fce007a6a9"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "imath"
  depends_on "libaec"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args + %w[
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DUSE_HDF5=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "prman/Tests/testdata/cube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}/abcls #{pkgshare}/cube.abc")
  end
end