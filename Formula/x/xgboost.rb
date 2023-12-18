class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https:xgboost.ai"
  url "https:github.comdmlcxgboost.git",
      tag:      "v2.0.2",
      revision: "41ce8f28b269dbb7efc70e3a120af3c0bb85efe3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1085c7b98a03353b0b8d40127f7c868066dda29458cb01b37ef0f9574e3f0c86"
    sha256 cellar: :any,                 arm64_ventura:  "e84097efe5106d08c321b826d127c754fb56551fd4a2dcad2e0760b7574c056f"
    sha256 cellar: :any,                 arm64_monterey: "07cc3c5d5931ac8e4a80b4a7b470fcea6511e9911b09e757d297384c812da0d1"
    sha256 cellar: :any,                 sonoma:         "765544de3c67cebf8ace5c0b9204661485f2959f30cb6a714151cc9bd777331f"
    sha256 cellar: :any,                 ventura:        "9b1244249694b14a8cf7f20f3937864ee53e1738ffbc2ea4c6764fcc1d713c75"
    sha256 cellar: :any,                 monterey:       "b342fb5cc8e8f3e2b7afbee3e16969bc9635a88190de6eff3059c95ba7335c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "887b43285eb4ab9fa307841253af2ccfae39c55c66679abe7b3808fa2fe0df43"
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
      make[2]: *** [srcCMakeFilesobjxgboost.dirtreeupdater_quantile_hist.cc.o] Error 254
    EOS
  end

  # Starting in XGBoost 1.6.0, compiling with GCC 5.4.0 results in:
  # srclinearcoordinate_common.h:414:35: internal compiler error: in tsubst_copy, at cppt.c:13039
  # This compiler bug is fixed in more recent versions of GCC: https:gcc.gnu.orgbugzillashow_bug.cgi?id=80543
  # Upstream issue filed at https:github.comdmlcxgboostissues7820
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

    cp_r (pkgshare"demo"), testpath
    cd "demodata" do
      cp "..CLIbinary_classificationmushroom.conf", "."
      system "#{bin}xgboost", "mushroom.conf"
    end
  end
end