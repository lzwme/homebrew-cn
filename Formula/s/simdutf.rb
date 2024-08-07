class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.3.2.tar.gz"
  sha256 "3c146fb80d775b869ae9b132f41981dc3266f616f589b5f45045d6a22fdabdca"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "488d8effc0ff299c3e7dd18b7fb1a52d5143dcbd6fbd1d1cb5ac19876f787c09"
    sha256 cellar: :any, arm64_ventura:  "f736afbc6542076b773d237d3ff9ab2d696ae5906baa93af693f4400e0d1cf63"
    sha256 cellar: :any, arm64_monterey: "fc37eb4c76cafd3076262864a754d4fd64e1912535994a518b65dcf6b80da58a"
    sha256 cellar: :any, sonoma:         "ae281a465585d771fdbd85978712c6ab4ef1e22c54ad03b45dcf395af55c669c"
    sha256 cellar: :any, ventura:        "266dc4b2326dd385c9d40617d3bcb130ed4083495eef6f1b547e49d4723bfab8"
    sha256 cellar: :any, monterey:       "892daf7a101d0664ea1a499520603fef27502dcc33aed8a4edeb30023f6651de"
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