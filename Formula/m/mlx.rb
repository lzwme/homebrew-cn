class Mlx < Formula
  include Language::Python::Virtualenv

  desc "Array framework for Apple silicon"
  homepage "https:github.comml-exploremlx"
  url "https:github.comml-exploremlxarchiverefstagsv0.5.0.tar.gz"
  sha256 "7c66d3e3b7bd6dad1909cb2b78c510580549e0ba5bf75d7066096a40c68fed9a"
  license "MIT"
  head "https:github.comml-exploremlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "29667b39f2b0f134e826eba5915f7bfbac0fee779cf3d270cd9cbf27e5b1e5e9"
    sha256 cellar: :any, arm64_ventura: "dedc6db706c69764efb8971ebcbd798ac2ce26443d9da3a9e73364638fa9beaa"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on xcode: ["14.3", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@3.12"

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc93d74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fadsetuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

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

    venv_root = buildpath"venv"
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_create_path "PYTHONPATH", venv_rootsite_packages
    venv = virtualenv_create(venv_root, python3)
    venv.pip_install resource("setuptools")

    env = { PYPI_RELEASE: version.to_s }
    env["DEV_RELEASE"] = "1" if build.head?
    with_env(env) do
      system python3, *Language::Python.setup_install_args(prefix, python3)
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