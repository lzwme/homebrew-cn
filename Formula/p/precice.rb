class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://ghfast.top/https://github.com/precice/precice/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "300df9dbaec066c1d0f93f2dbf055705110d297bca23fc0f20a99847a55a24f4"
  license "LGPL-3.0-or-later"
  revision 2
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9abc9b5dc315e2f6122a23bc29271563d9e1535d60d3ac9bb14dcdae9bf6b91"
    sha256 cellar: :any,                 arm64_sequoia: "cff60b51d0be859bb287bfcd23c37f59854b0577706960cc21ba7f80fc2cdfeb"
    sha256 cellar: :any,                 arm64_sonoma:  "f777da4443ad1937c1e58bcbfdc36bef97cf6aa90d5f7a54e96a5bed58f327f8"
    sha256 cellar: :any,                 sonoma:        "fa0aa86e52e05fee7d4571aa819a1655851e76d658e05721f59075a260a77133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ba43276ee38621a2dce00f90a71ce531e078d29fd60cc57c619a16481129fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26867f693aa6d51929e0a8eb7a58ed40b0ea3c0a407eb1bc9c241f0b55f58151"
  end

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "petsc"
  depends_on "python@3.14"

  uses_from_macos "libxml2"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"precice-version", "version"
    system bin/"precice-config-doc", "md"
    system bin/"precice-config-validate", pkgshare/"examples/solverdummies/precice-config.xml"
  end
end