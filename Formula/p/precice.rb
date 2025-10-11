class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://ghfast.top/https://github.com/precice/precice/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "300df9dbaec066c1d0f93f2dbf055705110d297bca23fc0f20a99847a55a24f4"
  license "LGPL-3.0-or-later"
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb0cd637e274ce5e83c95d940a1d930efe1b41bcb363dec56defd2280a9b0346"
    sha256 cellar: :any,                 arm64_sequoia: "bbdb841b40a0eddac119d9e1034c12066800022dc4d891daf8b373b8ddd2b1fb"
    sha256 cellar: :any,                 arm64_sonoma:  "910052a11fe80c822d84800165b986dde31d6ca79e5504cae71fd68a15ddb08f"
    sha256 cellar: :any,                 sonoma:        "e13276e0dfd3205a484d27c6ebcbd057f8d963c79caf8f950b5b2de4f89a7263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11aaba40a9bc9c18462d0cada723347e40cfcca836ac2a9514edaabea220b69b"
  end

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "petsc"
  depends_on "python@3.13"

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