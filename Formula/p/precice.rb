class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://ghfast.top/https://github.com/precice/precice/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "ef4713c938a1b2000d0b071175e1b45f9ec55c7aec4bbe7b65c3992edcc74ac7"
  license "LGPL-3.0-or-later"
  revision 3
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fde8fee2d3adc2ae82c254d3e277abe028452fb33b70e4efa5ae21a191fd74be"
    sha256 cellar: :any, arm64_sequoia: "3a4a8a5b81e853a7fff4717a85cf99ef627fb3d1b89f8391791238d3547ffbfa"
    sha256 cellar: :any, arm64_sonoma:  "a4902500314a863697c595b00af50372f3baee4e7e1a39efb6d9b03836bde7aa"
    sha256 cellar: :any, sonoma:        "df9e0b7f93c5421dc1c4fa96f9c80fb357a5a6be499642a10d4dfb1a9c53c6fc"
    sha256 cellar: :any, arm64_linux:   "ee46bd7191e79d3dd5ea54f80b0dd073cf2fc48bb1a43d6c8086c48d56d5c4b6"
    sha256 cellar: :any, x86_64_linux:  "406d1155d3064e911132a93b55ab37dc43c704e1a2ac9e0dcf3401e1f1e806a1"
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