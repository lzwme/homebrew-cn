class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https:www.openvdb.org"
  url "https:github.comAcademySoftwareFoundationopenvdbarchiverefstagsv11.0.0.tar.gz"
  sha256 "6314ff1db057ea90050763e7b7d7ed86d8224fcd42a82cdbb9c515e001b96c74"
  license "MPL-2.0"
  head "https:github.comAcademySoftwareFoundationopenvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc5e62a9f2595d7c261ae4f9c348f1d7553ccce882d35e20734a70bf679a5ce5"
    sha256 cellar: :any,                 arm64_ventura:  "8733d3e6cfddb121cb374e525f0566087a849ecaa71fc12740478db3a5468d54"
    sha256 cellar: :any,                 arm64_monterey: "bb093ceed9a66d515709d57be223538e6952d23ec4adb0936ac079f3ea4d6ec4"
    sha256 cellar: :any,                 sonoma:         "927ce4d9747c97797573e58cf52122da84183592951a4bb349cdddafc65b64f9"
    sha256 cellar: :any,                 ventura:        "1b002dffb093a1059369f3082d47cb5c5b1ca4618efbb14c20038d8b6a6a74a3"
    sha256 cellar: :any,                 monterey:       "04e14a58f5327d3ba75bc2ed622ce7bde26cf413e014f0ae9cdeb869a1b18612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e4f53689c06e81bb92a8b19f49326843ab4759bf2e17dde118a96d96a1cef25"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  fails_with gcc: "5"

  resource "homebrew-test_file" do
    url "https:artifacts.aswf.ioioaswfopenvdbmodelscube.vdb1.0.0cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    cmake_args = [
      "-DDISABLE_DEPENDENCY_VERSION_CHECKS=ON",
      "-DOPENVDB_BUILD_DOCS=ON",
      "-DUSE_NANOVDB=ON",
      "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}",
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *cmake_args
      system "make", "install"
    end
  end

  test do
    resource("homebrew-test_file").stage testpath
    system bin"vdb_print", "-m", "cube.vdb"
  end
end