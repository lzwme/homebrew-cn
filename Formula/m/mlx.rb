class Mlx < Formula
  desc "Array framework for Apple silicon"
  homepage "https:github.comml-exploremlx"
  url "https:github.comml-exploremlxarchiverefstagsv0.9.1.tar.gz"
  sha256 "2efdf30f7f5b45530920f833285588cdc174a7146e6a9dfd56a21b150514e288"
  license "MIT"
  head "https:github.comml-exploremlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "f1c53caa530c9d18a221adbf20ff08c1615379220ff14b8ec286fd4dc62034bf"
    sha256 cellar: :any, arm64_ventura: "6717fb4440cf645e18bae8a9d42740512099a97027596f1a512c145c6f2b603c"
  end

  depends_on "cmake" => :build
  depends_on xcode: ["14.3", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DMLX_BUILD_BENCHMARKS=OFF
      -DMLX_BUILD_EXAMPLES=OFF
      -DMLX_BUILD_METAL=OFF
      -DMLX_BUILD_PYTHON_BINDINGS=OFF
      -DMLX_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    env = { PYPI_RELEASE: version.to_s }
    env["DEV_RELEASE"] = "1" if build.head?
    env["MACOSX_DEPLOYMENT_TARGET"] = "#{MacOS.version.major}.#{MacOS.version.minor.to_i}" if OS.mac?
    with_env(env) do
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <cassert>

      #include <mlxmlx.h>

      int main() {
        mlx::core::array x({1.0f, 2.0f, 3.0f, 4.0f}, {2, 2});
        mlx::core::array y = mlx::core::ones({2, 2});
        mlx::core::array z = mlx::core::add(x, y);
        mlx::core::eval(z);
        assert(z.dtype() == mlx::core::float32);
        assert(z.shape(0) == 2);
        assert(z.shape(1) == 2);
        assert(z.data<float>()[0] == 2.0f);
        assert(z.data<float>()[1] == 3.0f);
        assert(z.data<float>()[2] == 4.0f);
        assert(z.data<float>()[3] == 5.0f);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{include}", "-L#{lib}", "-lmlx",
                    "-o", "test"
    system ".test"

    (testpath"test.py").write <<~EOS
      import mlx.core as mx
      x = mx.array(0.0)
      assert mx.cos(x) == 1.0
    EOS
    system python3, "test.py"
  end
end