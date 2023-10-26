class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v2.0.1",
      revision: "a408254c2f0c4a39a04430f9894579038414cb31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7bdbdc5540a96cd35fdb5f7f89a0224b7a9bb8709ae119bc19d2e92718d9c61d"
    sha256 cellar: :any,                 arm64_ventura:  "a769cec091a652d48871403c30830fa02b1214da10d0e0e6cc42adee2612f6ef"
    sha256 cellar: :any,                 arm64_monterey: "082c0668e5d3c5fffd3fbbdf4c82ac0fa3a06040a6662613998037e2e35b1fbb"
    sha256 cellar: :any,                 sonoma:         "d763050b10a3be07d0012369932ba0d691c1e39b909ef0e42b95adb013772f83"
    sha256 cellar: :any,                 ventura:        "714fb0a1193b44591f5c78ed857462da41f3d7ec209bdd5566f9389cd7013e5c"
    sha256 cellar: :any,                 monterey:       "42b6fac949974b291eba221ea866398411c1615b716dd178f6a819d6db5404a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07cefdeb6e2898a77bd61bc8f14643a8543ad8025297072710b55546cea4e8f7"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
    depends_on "libomp"
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      clang: error: unable to execute command: Segmentation fault: 11
      clang: error: clang frontend command failed due to signal (use -v to see invocation)
      make[2]: *** [src/CMakeFiles/objxgboost.dir/tree/updater_quantile_hist.cc.o] Error 254
    EOS
  end

  # Starting in XGBoost 1.6.0, compiling with GCC 5.4.0 results in:
  # src/linear/coordinate_common.h:414:35: internal compiler error: in tsubst_copy, at cp/pt.c:13039
  # This compiler bug is fixed in more recent versions of GCC: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=80543
  # Upstream issue filed at https://github.com/dmlc/xgboost/issues/7820
  fails_with gcc: "5"

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "demo"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    cp_r (pkgshare/"demo"), testpath
    cd "demo/data" do
      cp "../CLI/binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end