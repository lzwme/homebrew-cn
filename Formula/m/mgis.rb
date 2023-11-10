class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://ghproxy.com/https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-2.1.tar.gz"
  sha256 "f5b556aab130da0c423f395fe4c35d6bf509dd8fc958242f2e37ea788464aea9"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  revision 2
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "71742b6725218f4d2f6ff0aebdbfc040f3edc83d61112dd66fd67fe8a0db437a"
    sha256 cellar: :any,                 arm64_monterey: "703fa4d895ac3c7acca1d11625be5a0aa26da3053933f19963a0fcb40ed29fb2"
    sha256 cellar: :any,                 ventura:        "4da2f6342a60e9c71353875acffd6a21bb92720d7a6402b1fc283163129f3936"
    sha256 cellar: :any,                 monterey:       "7b9f309d493cfbd7fdf1218b5de31a2f9fc341335ca79b1e46c8ec8e8ed17ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6556e3e21bb4de6a483824c9baa874ec80511d0e95058a4312adb15238d38c2f"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    args = [
      "-Denable-portable-build=ON",
      "-Denable-website=OFF",
      "-Denable-enable-doxygen-doc=OFF",
      "-Denable-c-bindings=ON",
      "-Denable-fortran-bindings=ON",
      "-Denable-python-bindings=ON",  # requires boost-python
      "-Denable-fenics-bindings=OFF", # experimental and very limited
      "-Denable-julia-bindings=OFF",  # requires CxxWrap library
      "-Denable-enable-static=OFF",
      "-Ddisable_python_library_linking=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", "import mgis.behaviour"
    system python3, "-c", "import mgis.model"
  end
end