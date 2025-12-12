class Ptex < Formula
  desc "Texture mapping system"
  homepage "https://ptex.us/"
  url "https://ghfast.top/https://github.com/wdas/ptex/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "d3c2116f5cd650b22217fcdfad9586b6389173fd1d0b694413622743e52083ee"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e87dcb5a5f47a151aabe8b86e33125a61f77437aadbfe4fe794bf612fd7ca91"
    sha256 cellar: :any,                 arm64_sequoia: "6959719863c4ef46046b550acd60ef2f98671f5156017b9d6b904b463d619b03"
    sha256 cellar: :any,                 arm64_sonoma:  "e7eab4d9558a5b7bd09be12826dd9f6a595b865164209a2ea6070f825669d5d4"
    sha256 cellar: :any,                 sonoma:        "82123f7d97b11e4ae637b663b2c64b1f1b49d656a83233023126c18949256c7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc692869082c2c57bdb2f94f731458fc2773b38155f1c8ad78e7fca60ba51e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dfc6d70bcfd1b9c0b9329563032d08e01e75cede3221d023fe9ce35852f9f2f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libdeflate"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-wtest" do
      url "https://ghfast.top/https://raw.githubusercontent.com/wdas/ptex/v2.4.2/src/tests/wtest.cpp"
      sha256 "95c78f97421eac034401b579037b7ba4536a96f4b356f8f1bb1e87b9db752444"
    end

    testpath.install resource("homebrew-wtest")
    system ENV.cxx, "wtest.cpp", "-o", "wtest", "-I#{opt_include}", "-L#{opt_lib}", "-lPtex"
    system "./wtest"
    system bin/"ptxinfo", "-c", "test.ptx"
  end
end