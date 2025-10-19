class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://ghfast.top/https://github.com/dmlc/xgboost/releases/download/v3.1.0/xgboost-src-3.1.0.tar.gz"
  sha256 "4c42d35976067270a9255bf9ee290a706917bb3929a60cdd74d4dd3f1a9c86cc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c005f5a003d0a27cff580a1fbacf3823086c41bb0f0f4048f65fc442c2ca4db2"
    sha256 cellar: :any,                 arm64_sequoia: "3a930c379bcbbf1ea7e2620142bf17802588b5d224a123f8dff10573c35e6a17"
    sha256 cellar: :any,                 arm64_sonoma:  "2ebed4a04413641ccb002e1c3008bc14e84f3dfb1a8e29cc2983b61d0fdaaa23"
    sha256 cellar: :any,                 sonoma:        "186d96acba9c2f8e468f33a878aa4f9659fa1d94f0409a905cc6bd7d5e247dd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce949851df40f641ab4855d3fca89c0f1fad2e9854542795c64f1e454931a819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2a6878b1f19aae992aad9d3a8f2cb6aa15622726639298e6e4e15e8f0373e6e"
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