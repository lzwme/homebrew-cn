class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https:webassembly.org"
  url "https:github.comWebAssemblybinaryenarchiverefstagsversion_122.tar.gz"
  sha256 "53f01137c3c420e691f4e7fc781896c24eb4da2bc064a5c8a7495d073c3740e2"
  license "Apache-2.0"
  head "https:github.comWebAssemblybinaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(^version[._-](\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "82cc12ff8610ae70a63501d08d38d5769a8865091a1040d52c0474fdf8c387a3"
    sha256 cellar: :any,                 arm64_sonoma:  "23a3468699b79512ba041cf4805438fe5a5f8a145107935f28950cc451d5b9de"
    sha256 cellar: :any,                 arm64_ventura: "086f9437d5869a026429fb3533143d1420ea8496c087f3ecba3e7678046698f7"
    sha256 cellar: :any,                 sonoma:        "8cca689837f2354ca9272445a6933cff645cf307ae038100169f03e433e782b6"
    sha256 cellar: :any,                 ventura:       "460d84094956a7415dbdedddc14f54b2254bc2eaead45dab4fd156fd79dedb24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41f87267fedd7c0725431afc292b14b37cd288ba6a1fa1d48ad97b17e57b0557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b0999c614350ec60910e0e0acf5486ec1fc61326f4d9b8967cde45fc96c723"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTS=false", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test"
  end

  test do
    system bin"wasm-opt", "-O", pkgshare"testpassesO1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", (testpath"1.wast").read
  end
end