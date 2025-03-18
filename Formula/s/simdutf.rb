class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:simdutf.github.iosimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv6.3.1.tar.gz"
  sha256 "7a36c37db8f6dd36e03b1e894075c15f54dac6d0fe45026090eb56b941fcadca"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "09bb9c7ffc1534a37f37d0e43b879f511a54866a1d5f11a7293dfb47a754c0df"
    sha256 cellar: :any, arm64_sonoma:  "433d755550a96990888a435c88cb67c8a73555fa53b593fafb3784c35cf6ee38"
    sha256 cellar: :any, arm64_ventura: "97d8a756e2bb40b470d5dd5c577f0f5afad22f2da1aae28dc9da04c2fa60690c"
    sha256 cellar: :any, sonoma:        "110d9452f4b8c821f34ee81dd10751e755ef515cefa6e4105c249198038e788d"
    sha256 cellar: :any, ventura:       "e01ebce713a4d76bdf6eebe3d298bd6c636b67e548418049b8d03e51fbb9f2fb"
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
    system bin"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end