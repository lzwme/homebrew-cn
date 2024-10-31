class Mlx < Formula
  include Language::Python::Virtualenv

  desc "Array framework for Apple silicon"
  homepage "https:github.comml-exploremlx"
  # Main license is MIT while `metal-cpp` resource is Apache-2.0
  license all_of: ["MIT", "Apache-2.0"]
  head "https:github.comml-exploremlx.git", branch: "main"

  # TODO: Remove `stable` block when patch is no longer needed.
  stable do
    url "https:github.comml-exploremlxarchiverefstagsv0.19.1.tar.gz"
    sha256 "b6b76d5ddbe4ff7c667425fec2a67dc0abd258b734e708b1b45fd73910a2dc83"

    # Fix running tests in VMs.
    # https:github.comml-exploremlxpull1537
    patch do
      url "https:github.comml-exploremlxcommit1a992e31e835d05638a6f3cd53d4b136996a63c9.patch?full_index=1"
      sha256 "fd3a19a756e581840046e4b49365622025e2589bd33914602350a18c7ed0e2c2"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "8d95b1fec7643617c266d3c4ccf1700654241a68c6d1d07a3d977c6c721ac18c"
    sha256 cellar: :any, arm64_sonoma:  "058d61257c495ad8ce9f86e2f0753b0df84494fc2fcf242a5a5c58a7c7e54b06"
    sha256 cellar: :any, arm64_ventura: "6f01ec4b713c37b2afff3d4f76125ad98b6f7001240488460ce331af03fa50d2"
    sha256 cellar: :any, sonoma:        "3f5ccf6675d82014f6ed1f27845eb04f3bfeb7a0beaa203e982a277d6b649f69"
    sha256 cellar: :any, ventura:       "69f8f83d3ab154e999363aab5a106322580f2e39d80d1bb3a29958ae394c803d"
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

  # https:github.comml-exploremlxblobv#{version}CMakeLists.txt#L91C21-L91C97
  # Included in not_a_binary_url_prefix_allowlist.json
  resource "metal-cpp" do
    on_arm do
      url "https:developer.apple.commetalcppfilesmetal-cpp_macOS15_iOS18-beta.zip"
      sha256 "d0a7990f43c7ce666036b5649283c9965df2f19a4a41570af0617bbe93b4a6e5"
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