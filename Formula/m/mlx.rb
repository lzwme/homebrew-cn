class Mlx < Formula
  include Language::Python::Virtualenv

  desc "Array framework for Apple silicon"
  homepage "https://github.com/ml-explore/mlx"
  url "https://ghfast.top/https://github.com/ml-explore/mlx/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "f4e3feb2fae82c1186b46e795378384bd88dde73fd2d46ce5436db1ba153639f"
  license all_of: [
    "MIT", # main license
    "Apache-2.0", # metal-cpp resource
  ]
  head "https://github.com/ml-explore/mlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "446e77b9c2b72d5e8651698c34893b80efdfb939a46720b411654cca0dbc4d90"
    sha256 cellar: :any, arm64_sonoma:  "58164c157e6c4d3104c196692787642b4db736f0b7881a25533f474bec6608b5"
    sha256 cellar: :any, arm64_ventura: "f200bad791d2d0cc0023bfcb7da94ce7ca687ef82921d8fceb37e54030ea144b"
    sha256 cellar: :any, sonoma:        "015d35ddef2dd0e5c86545eb616e0ee4d455d468cee3de546617151981ff712c"
    sha256 cellar: :any, ventura:       "a035113e8fea6954c0dafbcb5654cf8ab3ddbb3aa434ec5d0dcc553ec6da847a"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nanobind" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python-setuptools" => :build
  depends_on "robin-map" => :build
  depends_on :macos
  depends_on macos: :ventura
  depends_on "python@3.13"

  on_arm do
    depends_on xcode: ["15.0", :build] # for metal
  end

  on_intel do
    depends_on "openblas"
  end

  # https://github.com/ml-explore/mlx/blob/v#{version}/CMakeLists.txt#L98
  # Included in not_a_binary_url_prefix_allowlist.json
  resource "metal-cpp" do
    on_arm do
      url "https://developer.apple.com/metal/cpp/files/metal-cpp_macOS15_iOS18.zip"
      sha256 "0433df1e0ab13c2b0becbd78665071e3fa28381e9714a3fce28a497892b8a184"
    end
  end

  # Update to GIT_TAG at https://github.com/ml-explore/mlx/blob/v#{version}/mlx/io/CMakeLists.txt#L21
  resource "gguflib" do
    url "https://ghfast.top/https://github.com/antirez/gguf-tools/archive/af7d88d808a7608a33723fba067036202910acb3.tar.gz"
    sha256 "1ee2dde74a3f9506af9ad61d7638a5e87b5e891b5e36a5dd3d5f412a8ce8dd03"
  end

  def python3
    "python3.13"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["nlohmann-json"].opt_include}/nlohmann"
    (buildpath/"gguflib").install resource("gguflib")

    mlx_python_dir = prefix/Language::Python.site_packages(python3)/"mlx"

    # We bypass brew's dependency provider to set `FETCHCONTENT_TRY_FIND_PACKAGE_MODE`
    # which redirects FetchContent_Declare() to find_package() and helps find our `fmt`.
    # To re-block fetches, we use the not-recommended `FETCHCONTENT_FULLY_DISCONNECTED`.
    args = %W[
      -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: mlx_python_dir)}
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DFETCHCONTENT_SOURCE_DIR_GGUFLIB=#{buildpath}/gguflib
    ]
    args << if Hardware::CPU.arm?
      (buildpath/"metal_cpp").install resource("metal-cpp")
      "-DFETCHCONTENT_SOURCE_DIR_METAL_CPP=#{buildpath}/metal_cpp"
    else
      "-DMLX_ENABLE_X64_MAC=ON"
    end

    ENV["CMAKE_ARGS"] = (args + std_cmake_args).join(" ")
    ENV[build.head? ? "DEV_RELEASE" : "PYPI_RELEASE"] = "1"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "#{MacOS.version.major}.#{MacOS.version.minor.to_i}"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>

      #include <mlx/mlx.h>

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
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{include}", "-L#{lib}", "-lmlx",
                    "-o", "test"
    system "./test"

    (testpath/"test.py").write <<~PYTHON
      import mlx.core as mx
      x = mx.array(0.0)
      assert mx.allclose(mx.cos(x), mx.array(1.0))
    PYTHON
    system python3, "test.py"
  end
end