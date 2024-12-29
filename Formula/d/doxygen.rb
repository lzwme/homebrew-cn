class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https:www.doxygen.nl"
  url "https:doxygen.nlfilesdoxygen-1.13.0.src.tar.gz"
  mirror "https:downloads.sourceforge.netprojectdoxygenrel-1.13.0doxygen-1.13.0.src.tar.gz"
  sha256 "99434f8130f68be4a4a817e540620aedf95c617c68cc73434de04207abaaae46"
  license "GPL-2.0-only"
  head "https:github.comdoxygendoxygen.git", branch: "master"

  livecheck do
    url "https:www.doxygen.nldownload.html"
    regex(href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b0a19c2895f5754d56247ccf2a459bd8f3a97710f4856ca95e1145fa084ab0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8131e051436f2935c4eee37f18f558b2fa14f2c340ed9b44dafbf11d0093b1b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "314254eb7477efccfedbdde45f7ae947319fb01d77e49f675b4300091e207b46"
    sha256 cellar: :any_skip_relocation, sonoma:        "891711337eeb6555efba3bd3cb08d5a6d5491cb789bbe57c6477a3e2b848f909"
    sha256 cellar: :any_skip_relocation, ventura:       "e71152024711769d4ce7f032c41426505c22d1914030cb25f2df8b8ef9228ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95aca745b9f95beb9a17d2f24768b982f4a71299667cf3cacb2f090597532e0d"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build

  fails_with :clang do
    build 1000
    cause <<~EOS
      doxygen-1.11.0srcdatetime.cpp:100:19: error: no viable constructor or deduction guide for deduction of template arguments of 'array'
      static std::array g_specFormats
                        ^
    EOS
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which("python3") || which("python")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build", "-Dbuild_doc=1", *std_cmake_args
    man1.install buildpath.glob("buildman*.1")
  end

  test do
    system bin"doxygen", "-g"
    system bin"doxygen", "Doxyfile"
  end
end