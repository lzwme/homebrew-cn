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
    sha256 cellar: :any,                 arm64_sequoia: "337d62bf6f959d1d169fb53a7c188f91dfff9d711885b6aff7e7a699e95c693b"
    sha256 cellar: :any,                 arm64_sonoma:  "e4b08ec36e64c194e2d0b25973528438e5a3630b9160b6cbeec05964446951ef"
    sha256 cellar: :any,                 arm64_ventura: "51f91908f26d48c0d9cadefedb86cf362f61a706a7f94ce76284ade185cca665"
    sha256 cellar: :any,                 sonoma:        "e4585a4da8f90cad8e65e647e381fac0242cae2da58200b43e6502ffc4eb3a38"
    sha256 cellar: :any,                 ventura:       "cb74ce65fd1d11bc3829432dc7e4a0eec1521b1372968d22ac29382f6d5a1db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28101a52f9af445d2601475e476ad1a6da766d5bcb275d714107ad6b0305c823"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "flatbuffers"
  depends_on "jpeg-turbo"
  depends_on "libpng"
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

    system "cmake", "-S", ".", "-B", builddir,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DHalide_INSTALL_PYTHONDIR=#{prefixLanguage::Python.site_packages(python3)}",
                    "-DHalide_SHARED_LLVM=ON",
                    "-DPYBIND11_USE_FETCHCONTENT=OFF",
                    "-DFLATBUFFERS_USE_FETCHCONTENT=OFF",
                    "-DFETCHCONTENT_SOURCE_DIR_WABT=#{builddir}_depswabt-src",
                    *std_cmake_args
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