class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https:xgboost.ai"
  url "https:github.comdmlcxgboost.git",
      tag:      "v2.1.0",
      revision: "213ebf7796b757448dfa2cfba532074696fa1524"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7f6a6a2dd5e9d796c5ba95a34f65055b09ccec956bee0905747e1f324d0405b6"
    sha256 cellar: :any,                 arm64_ventura:  "2c68145f961730b300dc22acf8098da4936a991b13d9336ceb55797ed63de787"
    sha256 cellar: :any,                 arm64_monterey: "308c8b571df08efd75bf9e409d68d2a7a76ad2d7c4717713825f7f9cba239fc2"
    sha256 cellar: :any,                 sonoma:         "123579bc45c822159ee62ed51213266ee3689527b2a7b60857ec0c11f073d85a"
    sha256 cellar: :any,                 ventura:        "c2cb09ca22e370bcf811b0526907112439b5c515d207ac9745335fc348cd883c"
    sha256 cellar: :any,                 monterey:       "03be585c6fe93327248ab3ec6e417d42de015338448477ff94f0408c70cbd247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68ac2d435e6f0b0a807faf09007228ff651e8ba87d6cff5a05939f3f185167ba"
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
    cp_r (pkgshare"demo"), testpath

    (testpath"test.cpp").write <<~EOS
      #include <xgboostc_api.h>
      #include <iostream>

      int main() {
        std::string train_data = "#{testpath}demodataagaricus.txt.train?format=libsvm";

        DMatrixHandle dtrain;
        if (XGDMatrixCreateFromFile(train_data.c_str(), 0, &dtrain) != 0) {
          std::cerr << "Failed to load training data: " << train_data << std::endl;
          std::cerr << "Last error message: " << XGBGetLastError() << std::endl;
          return 1;
        }

         Create booster and set parameters
        BoosterHandle booster;
        if (XGBoosterCreate(&dtrain, 1, &booster) != 0) {
          std::cerr << "Failed to create booster" << std::endl;
          return 1;
        }
        if (XGBoosterSetParam(booster, "max_depth", "2") != 0) {
          std::cerr << "Failed to set parameter" << std::endl;
          return 1;
        }
        if (XGBoosterSetParam(booster, "eta", "1") != 0) {
          std::cerr << "Failed to set parameter" << std::endl;
          return 1;
        }
        if (XGBoosterSetParam(booster, "objective", "binary:logistic") != 0) {
          std::cerr << "Failed to set parameter" << std::endl;
          return 1;
        }

         Train the model
        for (int iter = 0; iter < 10; ++iter) {
          if (XGBoosterUpdateOneIter(booster, iter, dtrain) != 0) {
            std::cerr << "Failed to update booster" << std::endl;
            return 1;
          }
        }

         Free resources
        XGBoosterFree(booster);
        XGDMatrixFree(dtrain);

        std::cout << "Test completed successfully" << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lxgboost", "-o", "test"
    system ".test"
  end
end