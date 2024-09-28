class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http:alembic.io"
  url "https:github.comalembicalembicarchiverefstags1.8.6.tar.gz"
  sha256 "c572ebdea3a5f0ce13774dd1fceb5b5815265cd1b29d142cf8c144b03c131c8c"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comalembicalembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97541dbd48d88dbe679c25fa654fcaf2732ba4c231fff579adf21644543fc341"
    sha256 cellar: :any,                 arm64_sonoma:  "5b8948889d3693cf5481acebbf180edef818ad2650acbf2531f00d11b662d27f"
    sha256 cellar: :any,                 arm64_ventura: "54bd7fbaa1160d4798b5b3da9669e797214a21a17eaf5d53c4e32c57f3908d9a"
    sha256 cellar: :any,                 sonoma:        "6f2a1d7c8aac2261a1c4a144af2229ebe8f21328f6874bca18749bf7e6c84d24"
    sha256 cellar: :any,                 ventura:       "6bdbdcc31a712a6fb69ad706bae36fe508bf5ade77451f81e3279d86be3d3662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a41b30e30ac093af2bbe2a2a6c09dbe783833165a2f8babac20a104d5d33ab2b"
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

    pkgshare.install "prmanTeststestdatacube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}abcls #{pkgshare}cube.abc")
  end
end