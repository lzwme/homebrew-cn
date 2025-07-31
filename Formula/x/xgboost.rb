class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://ghfast.top/https://github.com/dmlc/xgboost/releases/download/v3.0.3/xgboost-src-3.0.3.tar.gz"
  sha256 "6598adf6a073a55cc87a31e6712fc6dab938a5317aeae7134a07067d51acdf3a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "337aa2fadab54451aee5f59ac27d502bd58ef19a9fa0b73fe134b33f10e9e07e"
    sha256 cellar: :any,                 arm64_sonoma:  "138aab3ddb94f9e497d4c1328098a20c96ab1644cc25b12f311c4532d73f34e1"
    sha256 cellar: :any,                 arm64_ventura: "5fa5b55a3ac8141ab387b6bba7906da0ea91a5c90a624bb9ba9f7fa1bb958123"
    sha256 cellar: :any,                 sonoma:        "e170435a944f005c0e55383cdbb852157f141ccc8c7862b156c8d38ea1322100"
    sha256 cellar: :any,                 ventura:       "c98adb1fc7b63a6adeaac6314555d6209a8143830d666c7d12c98b50ac89e097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbddde7b06a12827978db8f77238f7c83f4febf7ca2c3e5d275b3abc135860a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff00fedc4ca5f3c3139da4947d94899417a95b33c3545450529f9011f80d3b80"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
    depends_on "libomp"
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      clang: error: unable to execute command: Segmentation fault: 11
      clang: error: clang frontend command failed due to signal (use -v to see invocation)
      make[2]: *** [src/CMakeFiles/objxgboost.dir/tree/updater_quantile_hist.cc.o] Error 254
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "demo"
  end

  test do
    cp_r (pkgshare/"demo"), testpath

    (testpath/"test.cpp").write <<~CPP
      #include <xgboost/c_api.h>
      #include <iostream>

      int main() {
        std::string train_data = "#{testpath}/demo/data/agaricus.txt.train?format=libsvm";

        DMatrixHandle dtrain;
        if (XGDMatrixCreateFromFile(train_data.c_str(), 0, &dtrain) != 0) {
          std::cerr << "Failed to load training data: " << train_data << std::endl;
          std::cerr << "Last error message: " << XGBGetLastError() << std::endl;
          return 1;
        }

        // Create booster and set parameters
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

        // Train the model
        for (int iter = 0; iter < 10; ++iter) {
          if (XGBoosterUpdateOneIter(booster, iter, dtrain) != 0) {
            std::cerr << "Failed to update booster" << std::endl;
            return 1;
          }
        }

        // Free resources
        XGBoosterFree(booster);
        XGDMatrixFree(dtrain);

        std::cout << "Test completed successfully" << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lxgboost", "-o", "test"
    system "./test"
  end
end