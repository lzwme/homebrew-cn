class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://ghfast.top/https://github.com/precice/precice/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "ef4713c938a1b2000d0b071175e1b45f9ec55c7aec4bbe7b65c3992edcc74ac7"
  license "LGPL-3.0-or-later"
  revision 5
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c5326e3d31351f5acfc709701c5eed0b3fdfe7f2de7b5531c5319c649c5063ad"
    sha256 cellar: :any, arm64_tahoe:       "9658f11ea627712c3b9fd24fd83d0580bf62d9152b9763731e9097dd6f0ecfcc"
    sha256 cellar: :any, arm64_sequoia:     "683b34e194972331bf091c5f3234378b9f48a54db7c7d1f20d5a8d3944e8fe92"
    sha256 cellar: :any, arm64_linux:       "6585a612e9ef380789b2070337476c565ba167e976d8f74539eb78c49a278896"
    sha256 cellar: :any, x86_64_linux:      "ee6163d938395fe21433eb8c7ed5c0901db7c9335a7df54762463a8fcda3be8e"
  end

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "eigen" => :no_linkage
  depends_on "ginkgo"
  depends_on "kokkos"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "petsc"
  depends_on "python@3.14"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %W[
      -DPRECICE_FEATURE_GINKGO_MAPPING=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"precice-version", "version"
    system bin/"precice-config-doc", "md"
    system bin/"precice-config-validate", pkgshare/"examples/solverdummies/precice-config.xml"
  end
end