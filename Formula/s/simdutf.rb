class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.6.0.tar.gz"
  sha256 "98cc5761b638642b018a628b1609f1b2df489b555836fa88706055bb56a4d6fe"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "bdaad933c09592860cead59070c096ab32fdfe7d7a4d0ebbe1ec51e883030212"
    sha256 cellar: :any, arm64_sonoma:  "a0a8013422982a1677f077e59abe20d0a87deb0e75cac6b4f0c14380cf674b75"
    sha256 cellar: :any, arm64_ventura: "acb0846402bb83d60ca226e1ae41f3b7d281fbb3446f467aa1c6ca61bdf9c3e9"
    sha256 cellar: :any, sonoma:        "a8e1ab230a1055bca2f3c70a07fbcc01f7709a994ea1eb537c09722e32fc6036"
    sha256 cellar: :any, ventura:       "a38af342ca30054e65c2e4dd07a9c93764b0467b727c6a9848f290a6c0326c37"
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