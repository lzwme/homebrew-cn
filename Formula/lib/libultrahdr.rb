class Libultrahdr < Formula
  desc "Reference codec for the Ultra HDR format"
  homepage "https://developer.android.com/media/platform/hdr-image-format"
  url "https://ghfast.top/https://github.com/google/libultrahdr/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "588232d2c9adcd01541d48dc2e76f8448c52fea7fc2543e700a281b995ab50d2"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "57ccf50b3c4a1e4a9342153d9a1064719e277cc1f50b5b0070d13e9012119654"
    sha256 cellar: :any, arm64_sequoia: "61e30e2fc8dd3b684eac33c0ec63f62651281e92c3b35ee813dd9d0c7b818163"
    sha256 cellar: :any, arm64_sonoma:  "5f0a5e4150582c6cf26a60bfd22548fcabe09ae0e38e4a3c9632b07ac0036827"
    sha256 cellar: :any, sonoma:        "5959b6567fce9eb21dd6d9c356d5b216537b9201e40f46001d9f50f2d8fb32c4"
    sha256 cellar: :any, arm64_linux:   "095c2ba3a21c21f5798033bc19a30b740bdecceba5a9306f655d8cd73f5c6e08"
    sha256 cellar: :any, x86_64_linux:  "05a0e41def282f60aeda73e57abc66d1b15e6d410f8de6217b4e649404c64717"
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