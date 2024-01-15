class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https:people.engr.tamu.edudavissuitesparse.html"
  url "https:github.comDrTimothyAldenDavisSuiteSparsearchiverefstagsv7.5.1.tar.gz"
  sha256 "dccfb5f75aa83fe2edb4eb2462fc984a086c82bad8433f63c31048d84b565d74"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7a9e6567ae3266465272c949b33b9d4b4575970a2e0535f372c431b9c1b7d9f2"
    sha256 cellar: :any,                 arm64_ventura:  "8f4ab7e068195c0648e858cedd4b33031fe06c80f79b2d16f97b1a3137c9d764"
    sha256 cellar: :any,                 arm64_monterey: "ab49a068a3c9483c6adb612d11d8176170410511a3a16cb7095cb93f1e3826f3"
    sha256 cellar: :any,                 sonoma:         "d0ce081c195eabf1a07be8695284995e5b225215de063ddd47cb2e6628ef44bf"
    sha256 cellar: :any,                 ventura:        "16c101e9ba4ab64f1f64ef9a7d38ea15392fc9fe395b9fe691fa5413f7bae484"
    sha256 cellar: :any,                 monterey:       "46bf4562838037a6205e9d8e0fe6b6617bbf7d5b5177c4afcbe416ee4576128d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d78c8b2b464cd38d7bd3c692aef5daa9e6f3087303127fa6537f69ca3a19d662"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "metis"
  depends_on "mpfr"

  uses_from_macos "m4"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    # Avoid references to Homebrew shims
    if OS.mac?
      inreplace "GraphBLAScmake_modulesGraphBLAS_JIT_configure.cmake",
          "C_COMPILER_BINARY \"${CMAKE_C_COMPILER}\"", "C_COMPILER_BINARY \"#{ENV.cc}\""
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "KLUDemoklu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare"klu_simple.c",
                   "-I#{include}suitesparse", "-L#{lib}",
                   "-lsuitesparseconfig", "-lklu"
    assert_predicate testpath"test", :exist?
    assert_match "x [0] = 1", shell_output(".test")
  end
end