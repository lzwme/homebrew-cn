class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://ghfast.top/https://github.com/dmlc/xgboost/releases/download/v3.4.0/xgboost-src-3.4.0.tar.gz"
  sha256 "af4588b34c7fa1bfde258006beebbe181454f1fb74266f81883b23059af3b9fb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "681093a107f6e7e3caa51e653c3c46da56a14ce3c926c126c20e566aba663280"
    sha256 cellar: :any, arm64_sequoia: "653651ed2d7613f5c6464e3912a5d8a6e761150b779e1f2388e03c32a0b25062"
    sha256 cellar: :any, arm64_sonoma:  "a7169d33ff7653cecf95aae8be67bf97034d32e611de301e319b46199f58ccaa"
    sha256 cellar: :any, sonoma:        "6e551d15b73327a19c1c1acdd8b4743f870abeb295280fa07bd8d9c0094d95c8"
    sha256 cellar: :any, arm64_linux:   "d9d80d4bb3c5533a26f7428f4db2aad9538846b8de8b87e0dd3e2b59d5b37681"
    sha256 cellar: :any, x86_64_linux:  "d8aa739004e0548674bfa90c7f33c2adb256426e4b461ef7dcbbab0c6fc2e5e9"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
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
        std::string config = "{\\"uri\\": \\"" + train_data + "\\", \\"silent\\": 0}";

        DMatrixHandle dtrain;
        if (XGDMatrixCreateFromURI(config.c_str(), &dtrain) != 0) {
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