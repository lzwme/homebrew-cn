class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv6.1.1.tar.gz"
  sha256 "34f2e28ad9bbc1cd5909abe20b819e877200d48eb86d5839e042011909cbdf7a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2cb7575954dd9b8b89074cd779a565ded8341fab90054eb56071d5003e11fdeb"
    sha256 cellar: :any, arm64_sonoma:  "3e470497dec88685546f2a06356df09a66012113db5fa64bf884545bc4d4aa93"
    sha256 cellar: :any, arm64_ventura: "630e2a2c1b0423e3de5ff513ee240c92eeb58183667fe214fb045714f01195b6"
    sha256 cellar: :any, sonoma:        "927c905a133cc08a1c5b4850cf1a2578ac0417a5edcc3339d40a8ddf4c60f50b"
    sha256 cellar: :any, ventura:       "faedb7bb08728b818b03d69eec78ef227bcc6767c0fc1edb596f419ecb2517ca"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@76"

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