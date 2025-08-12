class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://ghfast.top/https://github.com/dmlc/xgboost/releases/download/v3.0.4/xgboost-src-3.0.4.tar.gz"
  sha256 "5388cc28f4f7725edc7d9eed4c4794a818df7c76c2d39652debe6fca7df770cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9c120494f92e22f3a11a817cf5e5b8bb5c41af62a037aecf5f0d81afa4f72739"
    sha256 cellar: :any,                 arm64_sonoma:  "126692238fb80eec0cd155e03f73a8d53c3b9ab6ba7c014d52e58a575bfeb624"
    sha256 cellar: :any,                 arm64_ventura: "4b8dd93190a7dc0f710bd7a3785324e73b878bbfe6574c8a70f4043074026456"
    sha256 cellar: :any,                 sonoma:        "6eadd09e6cb256e207c9ead507bcc3e3e42384cd9740d2ec5eb832c52d310144"
    sha256 cellar: :any,                 ventura:       "743d459eaba440eeb1c86b17d609ba4fe9f667aa72d27f4f11ebed72219547f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c3ab033edef39a30dbcea0282cbc30f90df45d981cc08f2b992c836ff5711ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b001b64454a41387fcda86f391366b0dc0688193bb501d69439f9dc01ba98b9c"
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