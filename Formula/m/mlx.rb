class Mlx < Formula
  include Language::Python::Virtualenv

  desc "Array framework for Apple silicon"
  homepage "https:github.comml-exploremlx"
  url "https:github.comml-exploremlxarchiverefstagsv0.24.1.tar.gz"
  sha256 "523c675ee6d17bdf95a5f623db32a5e029f6a4a8dce7b56be00a6e65e30766af"
  license all_of: [
    "MIT", # main license
    "Apache-2.0", # metal-cpp resource
  ]
  head "https:github.comml-exploremlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "f73bbdae7222f05d82f1a9ec9a0a49ac9d712eb62fbdb972d3ee9a039b63229a"
    sha256 cellar: :any, arm64_sonoma:  "4249c3a4c06421a562f46032bed6ecd193cd0c413c09473ea9c737f946d2e9f2"
    sha256 cellar: :any, arm64_ventura: "8796fc65d6a1184f97ac9b326a61c0400e500ccb675dd78deb4c9545525a38da"
    sha256 cellar: :any, sonoma:        "b96123523738920d6021e4c236ff57877dcb1c1ae9581e33fccd4b6b8625de60"
    sha256 cellar: :any, ventura:       "d9c975422eb79b59cd7104dbe58b93290d8e96d9de8a88d13af3047f0a0ef731"
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