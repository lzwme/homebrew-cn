class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:simdutf.github.iosimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv7.3.1.tar.gz"
  sha256 "357da74bae9a130ddaa9df2508622de983a8be56db319891afef4184efa858bf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "22f20ea2a72b4ba398b699e8e7c63e080e2f2ca7b75dfe5f678dfe4d20eb8e6e"
    sha256 cellar: :any,                 arm64_sonoma:  "e48a01edca981b998312a5bcef929859f8a526c68433b848fa6dd50eff1b020d"
    sha256 cellar: :any,                 arm64_ventura: "90280bba99b3782aba0552b5f1d4a9c1cb44cee83f095a41f672a96fbfa22b2d"
    sha256 cellar: :any,                 sonoma:        "0bfb1790e3f85a06961a5ca6c0c7d830ca071b8ba9f869c1361f3e695bfe192f"
    sha256 cellar: :any,                 ventura:       "0d15d0fedc4d9c7ed3c90240f1edba99ccaec134ed019a8ad0360f97a3af6cd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99e15e4c689f27f18a631c4236a3f2a210fa3ef0faa11758cd95cbf5d7bf8753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5a7696f5b377f78c4045d33c39548d4f1debc4324e9e73b56a1cf0825fb2d76"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@77"

  uses_from_macos "python" => :build

  # VERSION=#{version} && curl -s https:raw.githubusercontent.comsimdutfsimdutfv$VERSIONbenchmarksbase64CMakeLists.txt | grep -C 1 'VERSION'
  resource "base64" do
    url "https:github.comaklompbase64archiverefstagsv0.5.2.tar.gz"
    sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"
  end

  def install
    (buildpath"base64").install resource("base64")

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DFETCHCONTENT_SOURCE_DIR_BASE64=#{buildpath}base64
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "buildbenchmarksbenchmark" => "sutf-benchmark"
  end

  test do
    system bin"sutf-benchmark", "--random-utf8", "10240", "-I", "100"
  end
end