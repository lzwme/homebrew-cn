class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https:thelfer.github.iomgiswebindex.html"
  url "https:github.comthelferMFrontGenericInterfaceSupportarchiverefstagsMFrontGenericInterfaceSupport-2.2.tar.gz"
  sha256 "b3776d7b3a534ca626525a42b97665f7660ae2b28ea57b3f53fd7e8538da1ceb"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  revision 4
  head "https:github.comthelferMFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ad27b36ebc81202135e46f07239c5c10cd1184482f9884df7fcadec0e4885b2"
    sha256 cellar: :any,                 arm64_sonoma:  "a0bd94fdc5643eb1d3a09fa4b291447b8d6c275485a847ce20771f085509c161"
    sha256 cellar: :any,                 arm64_ventura: "fbfa822e7522ada5e5a1afcf89cc41b8efc88dbd8b8ae5decee40d795118f543"
    sha256 cellar: :any,                 sonoma:        "e4e6d58e29cda1d2d09ce6f312b0fcfb0875f72bae10306bb0905bd570fc41db"
    sha256 cellar: :any,                 ventura:       "cafc7308d207de8efe3e81fa225f8b3bb715d17f89c55792037978c0e4ebef2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6325e8cf522f4467e99b6066bd464dd2d1df521a14f3f7f4060ac36ac755baa6"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build

  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python@3.12"

  on_macos do
    depends_on "gcc"
  end

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
      "-DPython_ADDITIONAL_VERSIONS=#{Language::Python.major_minor_version python3}",
    ]

    site_packages = prefixLanguage::Python.site_packages(python3)
    args << "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: site_packages"mgis")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", "import mgis.behaviour"
    system python3, "-c", "import mgis.model"
  end
end