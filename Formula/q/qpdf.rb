class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://ghfast.top/https://github.com/qpdf/qpdf/releases/download/v12.3.2/qpdf-12.3.2.tar.gz"
  sha256 "6cba2f9f2cd887d905faeb99e0e51a307b217920d1bbf3e9cfbb2e8178a2deda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe0fd011dc8311bb3cae11b34341c9c7e067e9ef17c973a19f69b1d20d7460d0"
    sha256 cellar: :any,                 arm64_sequoia: "850f009fea4ded376f7b5fa4a575b91a491435af2f4f9a52cd009f45a111ee6b"
    sha256 cellar: :any,                 arm64_sonoma:  "33f1043fce8ded869ea9d1d3d41694eff327780653bba51d73d209556b588cf8"
    sha256 cellar: :any,                 sonoma:        "15e353a47e6629f5e545bbb84878b034dcc2339c1153ae8452da154123fc3ef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1153b497aea393021e0fe0f0e07a1e283bb35d06b7159967bdacbf01db720507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed3fcc5ef9565b5f1cb74c033dbe34f9621b20efeed0949a2af606a6dfdb27fc"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_IMPLICIT_CRYPTO=0",
                    "-DREQUIRE_CRYPTO_OPENSSL=1",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"qpdf", "--version"
  end
end