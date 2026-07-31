class Libultrahdr < Formula
  desc "Reference codec for the Ultra HDR format"
  homepage "https://developer.android.com/media/platform/hdr-image-format"
  url "https://ghfast.top/https://github.com/google/libultrahdr/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "54d3f36c1d2b56ef9b8e63fd3f5fcac56c2c4540f8a56e0cc952f5010d790191"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1fd63bc9d43bfa89aa24499fcf72c9c00c081a137e08567ac27da01d0b78acec"
    sha256 cellar: :any, arm64_sequoia: "643c7e30a4fa790b78756e84beb78660c38ed3e8a2c4f5b00c156a788647e7dd"
    sha256 cellar: :any, arm64_sonoma:  "da9af01fafaf97b3526b55b1399fe142e2fd971a4d137096d12cc2bf1157a401"
    sha256 cellar: :any, sonoma:        "6333837b8b5d1445d807331bd9314c291b105ed9f1c661d22ddcec641bcc0e85"
    sha256 cellar: :any, arm64_linux:   "9b999d8bfa8a98ed2ad1396efb9352cebc379da030f100a4aff3347ec1658dad"
    sha256 cellar: :any, x86_64_linux:  "923b3365d3965055c3d6ffa5f7b6b5108cfb6e9b46242b44c6a6d0720ae184c0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "jpeg-turbo"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("pkg-config --modversion libuhdr")

    (testpath/"test.cpp").write <<~CPP
      #include <ultrahdr_api.h>
      #include <iostream>

      int main() {
        uhdr_codec_private_t* encoder = uhdr_create_encoder();
        if (encoder == nullptr) return 1;
        uhdr_release_encoder(encoder);

        std::cout << "encoder ok" << std::endl;
        return 0;
      }
    CPP

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libuhdr").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", *pkg_config_cflags
    assert_match "encoder ok", shell_output("./test")
  end
end