class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.3.4.tar.gz"
  sha256 "ccc9dab0c38bf0ee67374592707c6e6002148b99fb225a6b0c4604e90cfcbbc4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "cce2828d8164367cc85f92e3d40b5df1611e96d887ebbd9bd8d4b29ee9607449"
    sha256 cellar: :any, arm64_ventura:  "a375de754fe33fccf9ccad121b3c926291244f7c57766dc9619b305d5e0eee17"
    sha256 cellar: :any, arm64_monterey: "260634a4a3c7db10c3595c68548be742d5fa46fcf9b388231b90f11fe64a0bda"
    sha256 cellar: :any, sonoma:         "ac7ab8cbb6bf20cf22eb752c45e374e0bf10d426aec743462d4095693f0f00b5"
    sha256 cellar: :any, ventura:        "4758c8c5bf360160b978862a3383e89dd1828cb864bd1663d5d92fee19ebbef2"
    sha256 cellar: :any, monterey:       "1780b961c83833642ff4b6a7309d67a46c924528509c114c1cad1418b8a2ee95"
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