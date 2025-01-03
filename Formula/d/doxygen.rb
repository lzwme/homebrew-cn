class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https:www.doxygen.nl"
  url "https:doxygen.nlfilesdoxygen-1.13.1.src.tar.gz"
  mirror "https:downloads.sourceforge.netprojectdoxygenrel-1.13.1doxygen-1.13.1.src.tar.gz"
  sha256 "b593a17e9f7dd00c253d5bb18f05b84632136e89753b87fe366c858ea63f6e62"
  license "GPL-2.0-only"
  head "https:github.comdoxygendoxygen.git", branch: "master"

  livecheck do
    url "https:www.doxygen.nldownload.html"
    regex(href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c8bd1f7deaa6895caddf9bcd45321f94686cc57b624530f77883e4a3cbfa7a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c67d73d3875684c887aa8597cc1e78d5a8e9bda9a6ed1a7b30814ec87cd931dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0d6ccf61ed4a84e5aca1db8592d71a4be52978df9b56213c386a33e10ed19f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0e1cf547a323e49369b8ea569b683c2943128f8184746b428ae29f22eb96138"
    sha256 cellar: :any_skip_relocation, ventura:       "69508b816402dbb70af58899d08044dceaba5da16b71bcb6229b9ee4a3212a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ae5bac2b224ce19d3b8625b863fb5f641b915f645e0358fb6af928dca354e87"
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