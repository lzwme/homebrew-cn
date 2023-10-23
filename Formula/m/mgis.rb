class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://ghproxy.com/https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-2.1.tar.gz"
  sha256 "f5b556aab130da0c423f395fe4c35d6bf509dd8fc958242f2e37ea788464aea9"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  revision 1
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d35eeacabd8ade1b19dee20bcc839bc9cf3d4d75f33bed4021f5a41d1b74edc3"
    sha256 cellar: :any,                 arm64_monterey: "fba6608e28cafcd3e8833ff2773d39c0115572231fe86404c034b8fc9f5ee958"
    sha256 cellar: :any,                 ventura:        "14b53d88997a7d620f05cad5be6c8eed0a6e8e8b981118e7556d6092523a1568"
    sha256 cellar: :any,                 monterey:       "b38dff28f3b85c1dc7f7f62b8cab0ff25a589f91296caaa76d605b28fae46c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd8a72d6f65924ff42a7967e69ea008d8d54ea627abbeed8d0688c3bb20005cf"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python@3.11"

  def python3
    which("python3.11")
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