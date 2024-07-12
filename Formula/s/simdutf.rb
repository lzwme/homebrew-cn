class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.3.0.tar.gz"
  sha256 "9b568d6e66b14810bdbcf645f19b103475ab8175201b5c85828222c0ff0a735c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "6fd0b26c5407961961cabd0aae53862106fc357ce009237794d91fe6d97fbf3e"
    sha256 cellar: :any, arm64_ventura:  "948b39bb608d6d4b4a5053ba0c5c678b434745465c46135cbd2721eb114cb181"
    sha256 cellar: :any, arm64_monterey: "b55273fa181a9ee266a455d0af1670b1f333857e9cd3f6cbbb2a927aa244130b"
    sha256 cellar: :any, sonoma:         "1755d5d46737b39f2fb52611c19e2a89ab228f72df7df2565a923f2ecb0cc676"
    sha256 cellar: :any, ventura:        "0eb808c9251ba05857affdb4c27a6cfb575ab92d2b79bb3d201795adee3ac68a"
    sha256 cellar: :any, monterey:       "fb349625f50748393e5bfe89eb3d654f4bba83a7bcf0d44dc4361e31649fef0b"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  # VERSION=#{version} && curl -s https:raw.githubusercontent.comsimdutfsimdutfv$VERSIONbenchmarksbase64CMakeLists.txt | grep -C 1 'name = "VERSION"'
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