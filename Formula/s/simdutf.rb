class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv6.1.0.tar.gz"
  sha256 "ef2903a7f085090c58f3acfa93a62733ae92a3f9b1d50800edec77a6816d7d67"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "8edb6effdc9e58705630a8b5daaa080c1e1aa7fb6a40ea86a89edd798c58f1d5"
    sha256 cellar: :any, arm64_sonoma:  "662dabb5eb1777dd4f8398fd0f445089eb3ef44696999bf2ac64686976468c69"
    sha256 cellar: :any, arm64_ventura: "4aaf96c3f8f01f3b36088954641f171ef0c68b9be2a21364f8f336486740d877"
    sha256 cellar: :any, sonoma:        "83dca3e27792e57ab4e6bd848d4bebacadf2378d9223d3bceb3244c4d77d7f9c"
    sha256 cellar: :any, ventura:       "7c58fe575ea47778c32dcd1a51a7bf5d8f2832d1dce6b396bf205f722a31ff30"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@76"

  uses_from_macos "python" => :build

  # VERSION=#{version} && curl -s https:raw.githubusercontent.comsimdutfsimdutfv$VERSIONbenchmarksbase64CMakeLists.txt | grep -C 1 'VERSION'
  resource "base64" do
    url "https:github.comaklompbase64archiverefstagsv0.5.2.tar.gz"
    sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"
  end

  # git patch for 6.1.0 release, upstream pr ref, https:github.comsimdutfsimdutfpull657
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches9988a01b6b424b0dc8c146dd2de1a99c58029e33simdutf6.1.0-git.patch"
    sha256 "38bf789ff3e617c2933953933b4199e30e58c914bc30d663f1c982417a6cc5f2"
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