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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "473c921b2a49ac91ddc541b66c654c6a903beaf4451be49e855cb97fb25de7d5"
    sha256 cellar: :any,                 arm64_sonoma:  "472ddf8483f0d0b9ab2c195d4cd4c31e4f852621039201a7dabd5cfdd24a9088"
    sha256 cellar: :any,                 arm64_ventura: "b7fac3254a4d060e2a5f00c50a7edcb59054b3a14dc503c185677a09aa9a9dbe"
    sha256 cellar: :any,                 sonoma:        "39d1d2350927c1157c49cd44359aad84c3f8107da3dfca7b7cad8ce24258350d"
    sha256 cellar: :any,                 ventura:       "40166a65e5f5b86d5f8ae2f981a3f436a0a69b27c7cebf141867eb9c31cacfa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "637ff487189822f7d0ea5c1f0cee6c4737f7f9364c1149f4636deac39baddee8"
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
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?
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