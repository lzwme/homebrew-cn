class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https:people.engr.tamu.edudavissuitesparse.html"
  url "https:github.comDrTimothyAldenDavisSuiteSparsearchiverefstagsv7.3.1.tar.gz"
  sha256 "b512484396a80750acf3082adc1807ba0aabb103c2e09be5691f46f14d0a9718"
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
    sha256 cellar: :any,                 arm64_sonoma:   "99a35a720fad6c15d7b8a705efe6f6b5d274ad181e9293dc33b7e6b52ea7c7e2"
    sha256 cellar: :any,                 arm64_ventura:  "1457c274b7bb1f63cd835204bf0d5d2f110b9de3d5ff101d0d690805b8517393"
    sha256 cellar: :any,                 arm64_monterey: "bd069f2d216187ad52eb3d449feeada150dfc8966d761bc7049286b54bdc499e"
    sha256 cellar: :any,                 sonoma:         "d2061d7168a7cfa33e0d931fd73b1f04d7e888c0b0cd8a049ac64257f3ddca97"
    sha256 cellar: :any,                 ventura:        "5189b27530c37b7a20b3e7446b3436a7140968b9f1520fc6fef6801b4d12c5d6"
    sha256 cellar: :any,                 monterey:       "ec3ae42fc3fcb42fbe42f2ad2bae039316b5f43b770542c91b2e81475990900f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9740d4012be76d0d736ffec0baf0ccc479990ed0665822411f0d1289b70eae9f"
  end

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"

  uses_from_macos "m4"

  conflicts_with "mongoose", because: "suite-sparse vendors libmongoose.dylib"

  def install
    # Force cmake to use our compiler shims
    if OS.mac?
      inreplace "GraphBLAScmake_modulesGraphBLAS_JIT_configure.cmake",
          "GB_C_COMPILER  \"${CMAKE_C_COMPILER}\"", "GB_C_COMPILER \"#{ENV.cc}\""
    end

    cmake_args = *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    args = [
      "INSTALL=#{prefix}",
      "BLAS=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "LAPACK=$(BLAS)",
      "MY_METIS_LIB=-L#{Formula["metis"].opt_lib} -lmetis",
      "MY_METIS_INC=#{Formula["metis"].opt_include}",
      "CMAKE_OPTIONS=#{cmake_args.join(" ")}",
      "JOBS=#{ENV.make_jobs}",
    ]

    # Parallelism is managed through the `JOBS` make variable and not with `-j`.
    ENV.deparallelize
    system "make", "library", *args
    system "make", "install", *args
    lib.install Dir["***.a"]
    pkgshare.install "KLUDemoklu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare"klu_simple.c",
           "-L#{lib}", "-lsuitesparseconfig", "-lklu"
    assert_predicate testpath"test", :exist?
    assert_match "x [0] = 1", shell_output(".test")
  end
end