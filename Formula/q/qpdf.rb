class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https:github.comqpdfqpdf"
  url "https:github.comqpdfqpdfreleasesdownloadv11.10.0qpdf-11.10.0.tar.gz"
  sha256 "6295349aa18049f5f970bf0717aa76904ce326b6b14ce230cf96895f0c679fe3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "295cae1dc59f77a62a6b6be15c114ffe11bf75556f5be996d0fb839f1c5d4536"
    sha256 cellar: :any,                 arm64_sonoma:  "a4f61b26d8ad19612cee325ff398e7b06b13be852e9911ede88cc286244d542d"
    sha256 cellar: :any,                 arm64_ventura: "52df3ae27a3051128dc251e4dc123cce6403514fe22cc297f2a18be5af55dbbb"
    sha256 cellar: :any,                 sonoma:        "4b879f559267320f39dd3a7eede7f219e115989302cc52185f80f0ad79c05fb2"
    sha256 cellar: :any,                 ventura:       "8032d783b4f916e9f20331a252cc1df342a51583d259c1cf5e27ddfc0ac2e109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "192df3df0b8d9dcd11ea92dd46d0a8f5c56d62ddcc45f80745ecdfbc600d667f"
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