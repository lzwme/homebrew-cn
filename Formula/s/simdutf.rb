class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.7.1.tar.gz"
  sha256 "fb63e8a3a495253ba36c545fac8aa311a7e3bdfd0cce505a5ded9c48491323d8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "8942cb08e3ad3059e71ba53fa35d30848bbb04bcc4b7732485b8b8f2c99791d4"
    sha256 cellar: :any, arm64_sonoma:  "732317981b1edf14c160534016822e89b16fc733e7d4cda1f236fb9d284461ee"
    sha256 cellar: :any, arm64_ventura: "cecf919f472e981d2c1d799edd478dd908877b028e9a3cce4c832963549492aa"
    sha256 cellar: :any, sonoma:        "5177b8e255c0b5990434c60bf5bcc906b5bc73722f7cf50b956ebbd082d4be93"
    sha256 cellar: :any, ventura:       "b7cc8a11f71a2cddbed4c5a834d6fea8c0bbf2726016122a2bda4b70ec4dc1fb"
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