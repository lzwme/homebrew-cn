class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.4.15.tar.gz"
  sha256 "188a9516ee208659cab9a1e5063c1b8385d63d171c2381e9ce18af97936d9879"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "6375a5f6d5f9922cba893a95bb7b0737d64de8f262ad59a4cde7b55dbb4dc715"
    sha256 cellar: :any, arm64_ventura:  "31a3f2b5dd344ac05d8471565d15401cfa327b97fff4117b8a6f42ea57ce375d"
    sha256 cellar: :any, arm64_monterey: "df136634437461caeb54ec9ae01d7812f93032ca4185407fef2d2e80ca372b25"
    sha256 cellar: :any, sonoma:         "ebc1d9bf2ef1dee6721f73f6e32fe431386f117a7d2bb80fec281b781718f7f6"
    sha256 cellar: :any, ventura:        "e7589081602a1c22a308c045916448c7edc99ce65f68390d3331270a3fb85a33"
    sha256 cellar: :any, monterey:       "58186f977e3836eb453aac1967bf64e8e202c655f7f0612e558305bafa06a71a"
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