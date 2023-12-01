class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://ghproxy.com/https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-2.2.tar.gz"
  sha256 "b3776d7b3a534ca626525a42b97665f7660ae2b28ea57b3f53fd7e8538da1ceb"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "823cb915cd07a7c459d8191d1ebd7b1b10438e7268a296a70aa388dc5f4fda94"
    sha256 cellar: :any,                 arm64_ventura:  "e258c7893d36636b4a91aeae410dc77df6c79d00915c8575d710188d1501e635"
    sha256 cellar: :any,                 arm64_monterey: "ac00bbb0d8a83283ec2513ca93b2d37895278279c77e5d42c99eb2da0b271cd7"
    sha256 cellar: :any,                 sonoma:         "b597c56a7db21e6bbbbf84c507f02fde8cfeb532eeccfa8615e84f7ea962082e"
    sha256 cellar: :any,                 ventura:        "e03a63b1568fc58caaa75111b521604eb4ab6abdd2229c78edba0fd6f42d6900"
    sha256 cellar: :any,                 monterey:       "f3314c9c40c4f6e7f2052a0868112596ba5852564e89c00e3482cdaf5c05374d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba49e66dc0879d3d33b48dcfa404b5dda54c047b3f77e14f6540226aa8d9c8c9"
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
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version >= 1500

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