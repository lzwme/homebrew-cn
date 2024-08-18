class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.3.8.tar.gz"
  sha256 "315ed0673ac500f856f2916d89632bcb1ee3ab880f62ea43f3dedb7b8b7ab6b5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1b9c1233b3cac8ca96c212210e736e901b8a22f5e2a8287959a794035d252217"
    sha256 cellar: :any, arm64_ventura:  "6160ec34cff7542fd7880be60dfc851bf410eb82781b3af503004b311ff64a49"
    sha256 cellar: :any, arm64_monterey: "c564b1d68a24590f572456913415ffb9578b23315dfe9838006b5305bb70987e"
    sha256 cellar: :any, sonoma:         "2158aac8303b650b7d9616fc19e84707429c091c1529eed95e3c2af77d70b03a"
    sha256 cellar: :any, ventura:        "187bdcf79d61380d806b0b6c7e2b133b49f46f75a27833efce316140eca7e260"
    sha256 cellar: :any, monterey:       "a18418f52a694e375a8e2db3d7ce61670ac4c4fc0f8dcdd3c779497a3ae5b26b"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

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