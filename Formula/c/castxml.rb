class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  license "Apache-2.0"
  revision 2
  head "https://github.com/CastXML/castxml.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/CastXML/CastXML/archive/refs/tags/v0.6.11.tar.gz"
    sha256 "fc5b49f802b67f98ecea10564bc171c660020836a48cecefc416681a2d2e1d3d"

    # Backport support for LLVM 21
    patch do
      url "https://github.com/CastXML/CastXML/commit/f4fdb9eebe3a03c8c6479a1cf420761a97e86824.patch?full_index=1"
      sha256 "33093a62dc22f98ab1f6b44a1eca7a668bc142e870069ea51fa5bbd44627dcae"
    end
    patch do
      url "https://github.com/CastXML/CastXML/commit/e71d56d34d308f410ac6f5493c5622e9701e210f.patch?full_index=1"
      sha256 "cab3ccec1795d8228a5f784c88b23846e2a90415d084513e9b8f237759a68da6"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "95fb7d267cd0be30fffb2f28a00e4f4f1783ea8381982819eab564862810922b"
    sha256 cellar: :any,                 arm64_sonoma:  "16ebcda57fcb0ae900940e1dac9f8a78fea0a3f648849b852d6cebffbaac1b76"
    sha256 cellar: :any,                 arm64_ventura: "509fc3979f3f7659b316d7414f20701784ccf69cde6a8410405eabd27b0e3e4a"
    sha256 cellar: :any,                 sonoma:        "03375795cb7b1704f1cd93b304bb1e6a11e02495fa7248884155175b7150fb27"
    sha256 cellar: :any,                 ventura:       "25974fd36e8a03296b65df304951d4cdd342f6e05b224adcbb474959f15ceb43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "491484e13a79e529bad359c0cf5cc994583689a2c293e0cd4ba4709a7fd64565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26eb128a91be1fcf60d791191f8d62434c745dd0c6f586ea67ad738e63a33e93"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      int main() {
        return 0;
      }
    CPP
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", ENV.cxx,
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end