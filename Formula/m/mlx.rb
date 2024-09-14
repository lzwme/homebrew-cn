class Mlx < Formula
  include Language::Python::Virtualenv

  desc "Array framework for Apple silicon"
  homepage "https:github.comml-exploremlx"
  url "https:github.comml-exploremlxarchiverefstagsv0.17.3.tar.gz"
  sha256 "56450b242e187957feee39e47940c9d57706daabcc1e8a7d172742ea4ae1053e"
  # Main license is MIT while `metal-cpp` resource is Apache-2.0
  license all_of: ["MIT", "Apache-2.0"]
  head "https:github.comml-exploremlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "16f224806caab57a46bda23589b79ea86629fe25bf5277da46533116c3a7e7d5"
    sha256 cellar: :any, arm64_ventura: "2d9928c9b1d82147711a34d2c3ee23e1b690f1a666bfa617564d85812ee6a662"
    sha256 cellar: :any, sonoma:        "faa8313c3f7357be83196cd128c1786ca71a7a99db42c92866dbb2933672c617"
    sha256 cellar: :any, ventura:       "8ab09b0468ffda96514ee79a764b8959af3af0c5b7c46c6e7907c937f9520786"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on :macos
  depends_on macos: :ventura
  depends_on "python@3.12"

  on_arm do
    depends_on xcode: ["15.0", :build]
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

  # https:github.comml-exploremlxblobv#{version}pyproject.toml#L4
  resource "nanobind" do
    url "https:files.pythonhosted.orgpackages3148dea3d75657366b5a75b9d57a4e4fa7b224d98e8385f72fc7762d504533dfnanobind-2.1.0-py3-none-any.whl"
    sha256 "a613a2ce750fee63f03dc8a36593be2bdc2929cb4cea56b38fafeb74b85c3a5f"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages27cbe754933c1ca726b0d99980612dc9da2886e76c83968c246cfb50f491a96bsetuptools-74.1.1.tar.gz"
    sha256 "2353af060c06388be1cecbf5953dcdb1f38362f87a2356c480b6b4d5fcfc8847"
  end

  def python3
    "python3.12"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["nlohmann-json"].opt_include}nlohmann"
    (buildpath"gguflib").install resource("gguflib")

    mlx_python_dir = prefixLanguage::Python.site_packages(python3)"mlx"
    venv = virtualenv_create(buildpath"venv", python3)
    venv.pip_install [resource("nanobind"), resource("setuptools")]
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    # We bypass brew's dependency provider to set `FETCHCONTENT_TRY_FIND_PACKAGE_MODE`
    # which redirects FetchContent_Declare() to find_package() and helps find our `fmt`.
    # To re-block fetches, we use the not-recommended `FETCHCONTENT_FULLY_DISCONNECTED`.
    args = std_cmake_args + %W[
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

    ENV["CMAKE_ARGS"] = args.join(" ")
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