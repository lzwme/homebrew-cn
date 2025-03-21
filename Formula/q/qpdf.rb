class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https:github.comqpdfqpdf"
  url "https:github.comqpdfqpdfreleasesdownloadv12.0.0qpdf-12.0.0.tar.gz"
  sha256 "7380fe9d5b612a6c912cbf3a5875d9e27c20db6c559ebca51360da5125f351b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3dbff64de52b5d5ed9e8c226480cd9ab0ccd6a02eab7ce58ff0a2b9d30fb095e"
    sha256 cellar: :any,                 arm64_sonoma:  "a383846cf9a02dbede64283084f87f3f609cf399ae094218f2165a8ebcb7fc43"
    sha256 cellar: :any,                 arm64_ventura: "7683c68e9c32e24e6ade2ef3dd874573c84460718ae4d6938f9a8b6b7f422bff"
    sha256 cellar: :any,                 sonoma:        "f6bcf73cb90386ceda5252824f5b9711e43a0eebc73a39fbe38d6502a518089c"
    sha256 cellar: :any,                 ventura:       "25a7234671a5dab044eca1514ee2ea0bc2851472fae626f8d1d0b52964dc7d4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbc6f899277fcdea2c6175e2971da1924e849f2752137cc1db9585de34b95698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3891c559f8b47d57a026336015f5ad73a91ac2a8f71a0e11e65e09f30dc79c1"
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
    system bin"qpdf", "--version"
  end
end