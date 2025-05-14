class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https:xgboost.ai"
  url "https:github.comdmlcxgboostreleasesdownloadv3.0.1xgboost-src-3.0.1.tar.gz"
  sha256 "46e6815fd24dec7e17ed6e9327cc062da098387ee36358e3e0a43fc43939a8b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f54c01465fa7cd273fb4e3a16bbab055c42d4e17bd9fdbc63f22a0fc33378d7b"
    sha256 cellar: :any,                 arm64_sonoma:  "89e1e89aceac1097cdabe6c1e6dbff5c8e8f8b5507f1c7f76d5e7a1969ecb2af"
    sha256 cellar: :any,                 arm64_ventura: "b2e320c5d39b13451d1f2b60507c8e39ce783cfa092ef29a8e40e029fc160edb"
    sha256 cellar: :any,                 sonoma:        "24c4a206e034d793a6a6f41d39f65714b9ae515b02c699ce571362db020ef064"
    sha256 cellar: :any,                 ventura:       "4e8fedb128abd3b2937123e82ad0794d564c3c5c605da9d4ba6d0fea7acee01e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcd0ba0ccfb88a2685ee3075b9e63172403158060cf08c9cd986f106796cde52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b57b046b244948706780f88732f47e06e813d74510785592edf29c3dd7dcd83"
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
      make[2]: *** [srcCMakeFilesobjxgboost.dirtreeupdater_quantile_hist.cc.o] Error 254
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
    cp_r (pkgshare"demo"), testpath

    (testpath"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lxgboost", "-o", "test"
    system ".test"
  end
end