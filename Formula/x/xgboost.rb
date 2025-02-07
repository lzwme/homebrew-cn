class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https:xgboost.ai"
  url "https:github.comdmlcxgboostreleasesdownloadv2.1.4xgboost-2.1.4.tar.gz"
  sha256 "b6ce5870d03cc1233cad5ff8460f670a2aff78625adfb578c0b9eec3b8b88406"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45584408cfb5974a7a160c856b552731244033f599c6abe43757a11cf59d52cd"
    sha256 cellar: :any,                 arm64_sonoma:  "d8fe6f0f5b263fbacec037d1759b2bbf153e349d7c3794c795420db6f1ebdd1c"
    sha256 cellar: :any,                 arm64_ventura: "0149c8754df7b50ea90da45e83a0ec5987b20e47fc0e4520bd3ceb794071577b"
    sha256 cellar: :any,                 sonoma:        "2e10271e89bc9acb501934f1de692333a7b97f41b68774a33230ff4d0fd6e9f2"
    sha256 cellar: :any,                 ventura:       "2af882c2b535c533107bcb2b8115613f08c0fcb15c1d462242c75ef7200dc44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aff5f14417875de40f9acadd0c7bfbb142b1a503aa34de719dda5efae28df60"
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