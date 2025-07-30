class Pocl < Formula
  desc "Portable Computing Language"
  homepage "https://portablecl.org/"
  url "https://ghfast.top/https://github.com/pocl/pocl/archive/refs/tags/v7.0.tar.gz"
  sha256 "f55caba8c3ce12bec7b683ce55104c7555e19457fc2ac72c6f035201e362be08"
  license "MIT"
  head "https://github.com/pocl/pocl.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "bed2f14a22b1359771e17f6847e4d37917b9df50a4b746973bafd0feb0e8d9cb"
    sha256 arm64_sonoma:  "195ef004effb16a6625b5cca3330af4c5c6f68d7c0abfb969744cf5b9d13ce44"
    sha256 arm64_ventura: "175075666e8fbbb021122229215bd2b34530a8913d610983e33ca4c5d39b4711"
    sha256 sonoma:        "688a040a1d181481d9552d94fe7dd315006289ff62cf03f2f7d35bfbdaceccf7"
    sha256 ventura:       "3c1a6a049ec3e48e0d322a239231c0a5be3e5f2a916a007605bb12e60d31339a"
    sha256 arm64_linux:   "47497124009c872e155bedc44ca09099131cac2ae02f2d5549b2556516d56548"
    sha256 x86_64_linux:  "33874a69f7385e19a0b117294d85da156090fd7f5b784302bc2cf25769195374"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkgconf" => :build
  depends_on "hwloc"
  depends_on "llvm"
  depends_on "opencl-icd-loader"
  uses_from_macos "python" => :build

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    # Install the ICD into #{prefix}/etc rather than #{etc} as it contains the realpath
    # to the shared library and needs to be kept up-to-date to work with an ICD loader.
    # This relies on `brew link` automatically creating and updating #{etc} symlinks.
    rpaths = [loader_path, rpath(source: lib/"pocl")]
    rpaths << llvm.opt_lib.to_s if OS.linux?
    args = %W[
      -DPOCL_INSTALL_ICD_VENDORDIR=#{prefix}/etc/OpenCL/vendors
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DINSTALL_OPENCL_HEADERS=OFF
      -DWITH_LLVM_CONFIG=#{llvm.opt_bin}/llvm-config
      -DLLVM_PREFIX=#{llvm.opt_prefix}
      -DLLVM_BINDIR=#{llvm.opt_bin}
      -DLLVM_LIBDIR=#{llvm.opt_lib}
      -DLLVM_INCLUDEDIR=#{llvm.opt_include}
    ]
    if Hardware::CPU.intel?
      # Only x86_64 supports "distro" which allows runtime detection of SSE/AVX
      args << "-DKERNELLIB_HOST_CPU_VARIANTS=distro"
    elsif OS.mac?
      args << "-DLLC_HOST_CPU=apple-m1"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/poclcc"
  end

  test do
    ENV["OCL_ICD_VENDORS"] = "#{opt_prefix}/etc/OpenCL/vendors" # Ignore any other ICD that may be installed
    cp pkgshare/"examples/poclcc/poclcc.cl", testpath
    system bin/"poclcc", "-o", "poclcc.cl.pocl", "poclcc.cl"
    assert_path_exists testpath/"poclcc.cl.pocl"
    # Make sure that CMake found our OpenCL headers and didn't install a copy
    refute_path_exists include/"OpenCL"
  end
end