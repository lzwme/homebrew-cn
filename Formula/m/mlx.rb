class Mlx < Formula
  include Language::Python::Virtualenv

  desc "Array framework for Apple silicon"
  homepage "https:github.comml-exploremlx"
  url "https:github.comml-exploremlxarchiverefstagsv0.24.0.tar.gz"
  sha256 "d8d92963d84b004b9b89a820f1d53c48872de10e192d7d7e84d132ce7419447f"
  license all_of: [
    "MIT", # main license
    "Apache-2.0", # metal-cpp resource
  ]
  head "https:github.comml-exploremlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0360a7258e9d560414b5996ade8d20e079bf7ae18edc0182c4d6edfef063649f"
    sha256 cellar: :any, arm64_sonoma:  "3b4e0a8acbc2ee9bf2118ce10ea3836a645e55ec8e93f83d303bf0ba06b90544"
    sha256 cellar: :any, arm64_ventura: "04de50120f80bddcc700af48c8d75f8ba1b810148eb9ace3d39a72bf91713b90"
    sha256 cellar: :any, sonoma:        "718b28445c122e9db2a46328dfc3db8b429115401a91ce357da6049d42746f3b"
    sha256 cellar: :any, ventura:       "0557ef5b058a849a61556f7ac9274f9fbe722943548ba25ab299bfed9a7f5eea"
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

  # https:github.comml-exploremlxblobv#{version}CMakeLists.txt#L98
  # Included in not_a_binary_url_prefix_allowlist.json
  resource "metal-cpp" do
    on_arm do
      url "https:developer.apple.commetalcppfilesmetal-cpp_macOS15_iOS18.zip"
      sha256 "0433df1e0ab13c2b0becbd78665071e3fa28381e9714a3fce28a497892b8a184"
    end
  end

  # Update to GIT_TAG at https:github.comml-exploremlxblobv#{version}mlxioCMakeLists.txt#L21
  resource "gguflib" do
    url "https:github.comantirezgguf-toolsarchiveaf7d88d808a7608a33723fba067036202910acb3.tar.gz"
    sha256 "1ee2dde74a3f9506af9ad61d7638a5e87b5e891b5e36a5dd3d5f412a8ce8dd03"
  end

  def python3
    "python3.13"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["nlohmann-json"].opt_include}nlohmann"
    (buildpath"gguflib").install resource("gguflib")

    mlx_python_dir = prefixLanguage::Python.site_packages(python3)"mlx"

    # We bypass brew's dependency provider to set `FETCHCONTENT_TRY_FIND_PACKAGE_MODE`
    # which redirects FetchContent_Declare() to find_package() and helps find our `fmt`.
    # To re-block fetches, we use the not-recommended `FETCHCONTENT_FULLY_DISCONNECTED`.
    args = %W[
      -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: mlx_python_dir)}
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DFETCHCONTENT_SOURCE_DIR_GGUFLIB=#{buildpath}gguflib
    ]
    args << if Hardware::CPU.arm?
      (buildpath"metal_cpp").install resource("metal-cpp")
      "-DFETCHCONTENT_SOURCE_DIR_METAL_CPP=#{buildpath}metal_cpp"
    else
      "-DMLX_ENABLE_X64_MAC=ON"
    end

    ENV["CMAKE_ARGS"] = (args + std_cmake_args).join(" ")
    ENV[build.head? ? "DEV_RELEASE" : "PYPI_RELEASE"] = "1"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "#{MacOS.version.major}.#{MacOS.version.minor.to_i}"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{include}", "-L#{lib}", "-lmlx",
                    "-o", "test"
    system ".test"

    (testpath"test.py").write <<~PYTHON
      import mlx.core as mx
      x = mx.array(0.0)
      assert mx.allclose(mx.cos(x), mx.array(1.0))
    PYTHON
    system python3, "test.py"
  end
end