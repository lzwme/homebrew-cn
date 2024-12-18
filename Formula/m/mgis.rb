class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https:thelfer.github.iomgiswebindex.html"
  url "https:github.comthelferMFrontGenericInterfaceSupportarchiverefstagsMFrontGenericInterfaceSupport-2.2.tar.gz"
  sha256 "b3776d7b3a534ca626525a42b97665f7660ae2b28ea57b3f53fd7e8538da1ceb"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  revision 5
  head "https:github.comthelferMFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d2baa0db73a350e2e2c68b11bc65cc48c4c11a35b475b3468e29624259d898a"
    sha256 cellar: :any,                 arm64_sonoma:  "23031a0e15803505ccb66196fc97fe05b8c64a0a4a734836d9d160d0234e33ea"
    sha256 cellar: :any,                 arm64_ventura: "d8db5a8b0f0963ff3bc72325c44b5db3f51f8dca547e8cf0991687e87132fd60"
    sha256 cellar: :any,                 sonoma:        "74adba719180e893aa6e23d60e4f5a058e2e8ddc6ac7fc6bd6ceb2da3ff457ae"
    sha256 cellar: :any,                 ventura:       "987ed0eb220f4e3c1f04bf721bbc8121b33a6eaae1bb2a76a0a8e6d229ea90f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc33147428bbbf16053013fff48b01ea6b099aada45ecb0a5b65d8a1d9b9ea2"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build

  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python@3.13"

  on_macos do
    depends_on "gcc"
  end

  def python3
    which("python3.13")
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