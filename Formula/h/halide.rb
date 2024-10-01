class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https:halide-lang.org"
  url "https:github.comhalideHalidearchiverefstagsv18.0.0.tar.gz"
  sha256 "1176b42a3e2374ab38555d9316c78e39b157044b5a8e765c748bf3afd2edb351"
  license "MIT"
  revision 1
  head "https:github.comhalideHalide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "6f89eeee118f390658d2a52a67e41996ce89fcd058684961b27423d3b117eea9"
    sha256 cellar: :any,                 arm64_sonoma:  "e76b080cba6f9754412e6df3562d6e03bbf601233a84d9364c4d63ab98d2029c"
    sha256 cellar: :any,                 arm64_ventura: "b7dd542219917916ff63c94e29a2869cfbcf9758843c35f9990c06bed44e1348"
    sha256 cellar: :any,                 sonoma:        "ddd5a3737ec06e925dbfab1487021b3785ef8bcdb300e9163242b9a60c394873"
    sha256 cellar: :any,                 ventura:       "2f7c424d4540af2ae08aff4f90a019e83fbbd18a97b76571b7ad1456d638b83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f58f0eaa4f149d8685fd1f166cf3224995a89621c20e06a39fe0386e1ab71dd"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "flatbuffers"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "lld"
  depends_on "llvm"
  depends_on "python@3.12"

  fails_with :gcc do
    version "6"
    cause "Requires C++17"
  end

  # Check wabt version in `dependencieswasmCMakeLists.txt`.
  # TODO: Ask upstream to support usage of a system-provided wabt.
  # TODO: Do we really need a git checkout here?
  resource "wabt" do
    url "https:github.comWebAssemblywabt.git",
        tag:      "1.0.33",
        revision: "963f973469b45969ce198e0c86d3af316790a780"
  end

  def python3
    "python3.12"
  end

  def install
    builddir = buildpath"build"
    (builddir"_depswabt-src").install resource("wabt")

    site_packages = prefixLanguage::Python.site_packages(python3)
    rpaths = [rpath, rpath(source: site_packages"halide")]
    args = [
      "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
      "-DHalide_INSTALL_PYTHONDIR=#{site_packages}",
      "-DHalide_SHARED_LLVM=ON",
      "-DPYBIND11_USE_FETCHCONTENT=OFF",
      "-DFLATBUFFERS_USE_FETCHCONTENT=OFF",
      "-DFETCHCONTENT_SOURCE_DIR_WABT=#{builddir}_depswabt-src",
      "-DCMAKE_SHARED_LINKER_FLAGS=-llldCommon",
    ]
    odie "CMAKE_SHARED_LINKER_FLAGS can be removed from `args`" if build.bottle? && version > "18.0.0"
    system "cmake", "-S", ".", "-B", builddir, *args, *std_cmake_args
    system "cmake", "--build", builddir
    system "cmake", "--install", builddir
  end

  test do
    cp share"docHalidetutoriallesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output(".test")

    cp share"docHalide_Pythontutorial-pythonlesson_01_basics.py", testpath
    assert_match "Success!", shell_output("#{python3} lesson_01_basics.py")
  end
end