class Pocl < Formula
  desc "Portable Computing Language"
  homepage "https://portablecl.org/"
  license "MIT"
  revision 1

  stable do
    url "https://ghfast.top/https://github.com/pocl/pocl/archive/refs/tags/v7.0.tar.gz"
    sha256 "f55caba8c3ce12bec7b683ce55104c7555e19457fc2ac72c6f035201e362be08"
    depends_on "llvm@20" # TODO: use `llvm` next release, https://github.com/pocl/pocl/pull/1982
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "cd7832d6c7a66916ce6780910e68194e67bcabaa44350b90628533c6f9e3eaea"
    sha256 arm64_sonoma:  "87704651357fc84da96b8fd14331198193d5123ef11654c4482bfb1e2ef1d889"
    sha256 arm64_ventura: "9691c82147520af2ad73b91efd481eabe23522be587050e699533c68feb17d77"
    sha256 sonoma:        "50430f27b0122aaa37d926a8d61e478b0cc2aaf899cdbd692ba4f5cb2b047864"
    sha256 ventura:       "00667cb2b09818896f5d383d1663c0a8df110b999073c1640d58cddf4c16bed6"
    sha256 arm64_linux:   "8ee380dab7fa84eb7df26f804681008b56b209ac81daf7e1ecfa714a44f02462"
    sha256 x86_64_linux:  "36f28178328e6a60b659973f040fb33423e7f6cf2a6291f2b7c7c52e0c5232b8"
  end

  head do
    url "https://github.com/pocl/pocl.git", branch: "main"
    depends_on "llvm"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkgconf" => :build
  depends_on "hwloc"
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