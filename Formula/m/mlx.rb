class Mlx < Formula
  include Language::Python::Virtualenv

  desc "Array framework for Apple silicon"
  homepage "https://github.com/ml-explore/mlx"
  url "https://ghfast.top/https://github.com/ml-explore/mlx/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "7b5a43673f822e5ae28507f43127b10080db3e8da73d99a2efa5b34dbadd2bc4"
  license all_of: [
    "MIT", # main license
    "Apache-2.0", # metal-cpp resource
  ]
  head "https://github.com/ml-explore/mlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3097476b2d3d2eb1465b46dab420cc2f74fefd8fa9552a6a39d2f1d7aff6b856"
    sha256 cellar: :any, arm64_sonoma:  "d983e66d95d5ca1b4c3926961f8aece7fc64b78890819d19dfed202b185e3893"
    sha256 cellar: :any, arm64_ventura: "eee9634b7d436425772f4fe8e75cd7691605bc011e915536620181d77736ec21"
    sha256 cellar: :any, sonoma:        "b4cd7b526558359cbd3ba9f06893460b3d81dafce7072ecccab4d72c61ad82a7"
    sha256 cellar: :any, ventura:       "86235563bbe75dde52680cfef928991bdf075f63529bd197f04de1f86e7ec7d0"
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

  # https://github.com/ml-explore/mlx/blob/v#{version}/CMakeLists.txt
  # Included in not_a_binary_url_prefix_allowlist.json
  resource "metal-cpp" do
    on_arm do
      url "https://developer.apple.com/metal/cpp/files/metal-cpp_macOS15_iOS18.zip"
      sha256 "0433df1e0ab13c2b0becbd78665071e3fa28381e9714a3fce28a497892b8a184"
    end
  end

  # Update to GIT_TAG at https://github.com/ml-explore/mlx/blob/v#{version}/mlx/io/CMakeLists.txt
  resource "gguflib" do
    url "https://ghfast.top/https://github.com/antirez/gguf-tools/archive/8fa6eb65236618e28fd7710a0fba565f7faa1848.tar.gz"
    sha256 "9e30bc1eb82cc2231150d39ce37dcdd6f844d6994fba18da83fc537a487ba86f"
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