class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.6.1.tar.gz"
  sha256 "660bddffbc96a819b6a79ed95a8386bc71ae3950ee34155a5e4a0f2ef01eb04f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "1c05ea01b8c69e5dd5e3952bb76826ad8105f3642d26795728c9deebd442f427"
    sha256 cellar: :any, arm64_sonoma:  "c1f374f06e97a5664052804947728d3fe95b47c32d325ac0695170b56004bdff"
    sha256 cellar: :any, arm64_ventura: "60ac48ddc1eda53c89b275dda35ca870ea71f18a7485b9d1e047e6625ea5d1e3"
    sha256 cellar: :any, sonoma:        "9a363720727bab7fe999750652244e5700c9f56c97ecc2e954409b07acf35cda"
    sha256 cellar: :any, ventura:       "fcdb53675899b138fa9601e862845070c3cba6d647ea0c2e8a79123d829c2564"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@76"
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