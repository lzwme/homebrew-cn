class Pocl < Formula
  desc "Portable Computing Language"
  homepage "https:portablecl.org"
  url "https:github.compoclpoclarchiverefstagsv6.0.tar.gz"
  sha256 "de9710223fc1855f833dbbf42ea2681e06aa8ec0464f0201104dc80a74dfd1f2"
  license "MIT"
  revision 1
  head "https:github.compoclpocl.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "37c8ffad1dc251ad96358273fa375ee12c54f760c422545aeb6ca8d2e7f64345"
    sha256 arm64_sonoma:  "bf1d743d75558e518e6bf58c9b1414259ba4c715429d99fb4d5aa18ebe1f01d5"
    sha256 arm64_ventura: "d267fbd4dd48b16abaa5d8d7ae1d321848f48bf029bdc2850a7236f94fb576b5"
    sha256 sonoma:        "8e04092d421186a60170dadaa223f2bbe3b58702a3d1b7188a38b85635cf643b"
    sha256 ventura:       "f5b3f006dabc0dedeb515e70a641938917550889cdfc1bbdb1671b24bc9b4a05"
    sha256 x86_64_linux:  "5eb94f47dc4e2c6a34259afa0fb0ac297ee9b985c1934f8fc3e25d48ce009b14"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on "llvm@18"
  depends_on "opencl-icd-loader"
  uses_from_macos "python" => :build

  fails_with gcc: "5" # LLVM is built with GCC

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    # Install the ICD into #{prefix}etc rather than #{etc} as it contains the realpath
    # to the shared library and needs to be kept up-to-date to work with an ICD loader.
    # This relies on `brew link` automatically creating and updating #{etc} symlinks.
    rpaths = [loader_path, rpath(source: lib"pocl")]
    rpaths << llvm.opt_lib.to_s if OS.linux?
    args = %W[
      -DPOCL_INSTALL_ICD_VENDORDIR=#{prefix}etcOpenCLvendors
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DWITH_LLVM_CONFIG=#{llvm.opt_bin}llvm-config
      -DLLVM_PREFIX=#{llvm.opt_prefix}
      -DLLVM_BINDIR=#{llvm.opt_bin}
      -DLLVM_LIBDIR=#{llvm.opt_lib}
      -DLLVM_INCLUDEDIR=#{llvm.opt_include}
    ]
    # Avoid installing another copy of OpenCL headers on macOS
    args << "-DOPENCL_H=#{Formula["opencl-headers"].opt_include}CLopencl.h" if OS.mac?
    # Only x86_64 supports "distro" which allows runtime detection of SSEAVX
    args << "-DKERNELLIB_HOST_CPU_VARIANTS=distro" if Hardware::CPU.intel?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare"examples").install "examplespoclcc"
  end

  test do
    ENV["OCL_ICD_VENDORS"] = "#{opt_prefix}etcOpenCLvendors" # Ignore any other ICD that may be installed
    cp pkgshare"examplespoclccpoclcc.cl", testpath
    system bin"poclcc", "-o", "poclcc.cl.pocl", "poclcc.cl"
    assert_predicate testpath"poclcc.cl.pocl", :exist?
    # Make sure that CMake found our OpenCL headers and didn't install a copy
    refute_predicate include"OpenCL", :exist?
  end
end