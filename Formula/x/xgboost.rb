class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https:xgboost.ai"
  url "https:github.comdmlcxgboost.git",
      tag:      "v2.1.2",
      revision: "f1990391e0eb401bc1aa1309dd9f86085749c4a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c969ebbf56727606f05b267d02a1a01ed57ec811eb3b7bbe1ab2752a6a94854"
    sha256 cellar: :any,                 arm64_sonoma:  "4ee24eb50a4f2d2a0135748be4f7de1b85ac657e5f6816ee5fbb448299647a3e"
    sha256 cellar: :any,                 arm64_ventura: "a8bb2e604fd5d54825316c60d1d18653a99ccce326c94a55a47e1f0b3af4c393"
    sha256 cellar: :any,                 sonoma:        "b23c0bd2480f5a6a93961ebd344799d19ebf68b2da51d1f6a5db37ac22a44f2a"
    sha256 cellar: :any,                 ventura:       "2bf119825fdeed1068fb89919d5d0c34ba1b404d1a9fbab8405ab830541c3704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d992b9261cafd1d2a087b9049e2230c75c1bcfeb7826fbd85a403ba834527ad"
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