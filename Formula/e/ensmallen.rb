class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https:ensmallen.org"
  url "https:github.commlpackensmallenarchiverefstags2.22.0.tar.gz"
  sha256 "6794098afc9d41930c288ff111ecd821ca296892f1d4a6e3bab7c4028f0b6e59"
  license "BSD-3-Clause"
  head "https:github.commlpackensmallen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f42aace1bc9dbe8d382bb1032928bf0a1cc178c7ad4754aa7c0086c620ba027"
  end

  depends_on "cmake" => :build
  depends_on "armadillo"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <ensmallen.hpp>
      using namespace ens;
      int main()
      {
        test::RosenbrockFunction f;
        arma::mat coordinates = f.GetInitialPoint();
        Adam optimizer(0.001, 32, 0.9, 0.999, 1e-8, 3, 1e-5, true);
        optimizer.Optimize(f, coordinates);
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{Formula["armadillo"].opt_lib}",
                    "-larmadillo", "-o", "test"
  end
end