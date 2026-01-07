class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.16.0.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.16.0/doxygen-1.16.0.src.tar.gz"
  sha256 "32eff77733139d8c8e99d18c3aec30f51418c4d3a62834f263487e99e92d2fef"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31e9245bec767dfab52fbf6e4bd5bab98f1a346c49052b25120bd1d61520f190"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b9bb85a94c6ea92d6cadbc49ebccf7a8b23a7fcf74b24646f21507f78747254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5302cc0414d86caeba1703a98d6efc9228c4aff99e1e764d15df730dcd131cd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "50fea838fc43257cca8f78824eee427df6facbf4794e700ef23f44cd9c536a02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84efddb019931a90f61dff7706d9cea56745affd95a420651fba921fbb462333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "110d32567146762041534d53e999c76ed1a790e3a3140c4f4430b9ae65118d9c"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which("python3")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build", "-Dbuild_doc=1", *std_cmake_args
    man1.install buildpath.glob("build/man/*.1")
  end

  test do
    system bin/"doxygen", "-g"
    system bin/"doxygen", "Doxyfile"
  end
end