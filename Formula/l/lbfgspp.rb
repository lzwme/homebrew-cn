class Lbfgspp < Formula
  desc "Header-only C++ library for L-BFGS and L-BFGS-B algorithms"
  homepage "https:lbfgspp.statr.me"
  url "https:github.comyixuanLBFGSpparchiverefstagsv0.3.0.tar.gz"
  sha256 "490720b9d5acce6459cb0336ca3ae0ffc48677225f0ebfb35c9bef6baefdfc6a"
  license "MIT"
  head "https:github.comyixuanLBFGSpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a3fa9b668aa4ce459443ed3a31812abc4d072a8674ed7bf852ab0a8f1d01df45"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <EigenCore>
      #include <iostream>
      #include <LBFGS.h>

      using Eigen::VectorXd;
      using namespace LBFGSpp;

      class Rosenbrock {
      private:
          int n;
      public:
          Rosenbrock(int n_) : n(n_) {}
          double operator()(const VectorXd& x, VectorXd& grad) {
              double fx = 0.0;
              for(int i = 0; i < n; i += 2) {
                  double t1 = 1.0 - x[i];
                  double t2 = 10 * (x[i + 1] - x[i] * x[i]);
                  grad[i + 1] = 20 * t2;
                  grad[i]     = -2.0 * (x[i] * grad[i + 1] + t1);
                  fx += t1 * t1 + t2 * t2;
              }
              return fx;
          }
      };

      int main() {
          const int n = 10;
          LBFGSParam<double> param;
          param.epsilon = 1e-6;
          param.max_iterations = 100;
          LBFGSSolver<double> solver(param);
          Rosenbrock fun(n);
          VectorXd x = VectorXd::Zero(n);
          double fx;
          solver.minimize(fun, x, fx);
          std::cout << x.transpose() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, testpath"test.cpp", "-std=c++11",
           "-I#{include}", "-I#{Formula["eigen"].opt_include}eigen3",
           "-o", "test"
    assert_equal "1 1 1 1 1 1 1 1 1 1", shell_output(testpath"test").chomp
  end
end