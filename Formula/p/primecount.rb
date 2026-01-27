class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://ghfast.top/https://github.com/kimwalisch/primecount/archive/refs/tags/v8.1.tar.gz"
  sha256 "cef67e849a42d642e34579c8caa5e0629fba3e89a84f8279b3dfeb920a5dcb61"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ebf1a59073734f4e1825cba2fdbfdb8605970a45ec83994d303755ed50e99351"
    sha256 cellar: :any,                 arm64_sequoia: "bdf50eb309006b7b5333e3e3805f8b99f4f7a6c2e7d3b4848eec0eb881e5d00f"
    sha256 cellar: :any,                 arm64_sonoma:  "7d4a8f3fd457585dc300d3af5aa91d43922719da0a5777f3df342b99715d0626"
    sha256 cellar: :any,                 sonoma:        "d302af04297c3839965bb8fd0745e6c5a099556faa617b9722cd93af1fc81d39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83e972469286eef94f87a056cab175428ae658ebfe3798251516550cc629f242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a4dbf85d66cf71edd11b771f3da25922c8a9c8a254b1b22d1427a08571c63a2"
  end

  depends_on "cmake" => :build
  depends_on "primesieve"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON",
                                              "-DBUILD_LIBPRIMESIEVE=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "37607912018\n", shell_output("#{bin}/primecount 1e12")
  end
end