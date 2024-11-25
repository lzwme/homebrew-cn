class Libultrahdr < Formula
  desc "Reference codec for the Ultra HDR format"
  homepage "https:developer.android.commediaplatformhdr-image-format"
  url "https:github.comgooglelibultrahdrarchiverefstagsv1.3.0.tar.gz"
  sha256 "bf425e10a1a36507d47eb2711018e90effe11c76db8ecd4f10f4e1af9cb5288c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "905307f2f26285b508f922afc27a1800f521b458d4a23f3de4155f9d1d550db6"
    sha256 cellar: :any,                 arm64_sonoma:  "452c322b2272b9611d43f7bcf607959c7dc8b370ca09ba985ecc7a1b3f4b4f10"
    sha256 cellar: :any,                 arm64_ventura: "37a2b65a14283d0aeaf0b911929e7d14cdea11a7d4fbd35b0a5aa3a8e382934f"
    sha256 cellar: :any,                 sonoma:        "70c4fb49c02722a165a39b06f1ac470c23f36c6f6b41349b64f2a3745aaf5baf"
    sha256 cellar: :any,                 ventura:       "78861e16bf480d6766775801cb6c5da50f0ca433bb5c56090dd5e217ecaf2121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e203cb46ab293d6566dda0753a5d6a5e21d81e554b55ef3018809333b691dfba"
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
    (testpath"test.cpp").write <<~CPP
      #include <ultrahdr_api.h>
      #include <iostream>

      int main() {
        std::cout << "UltraHDR Library Version: " << UHDR_LIB_VERSION_STR << std::endl;

        uhdr_codec_private_t* encoder = uhdr_create_encoder();
        uhdr_release_encoder(encoder);

        return 0;
      }
    CPP

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libuhdr").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", "-o", "test", *pkg_config_cflags
    assert_match "UltraHDR Library Version: #{version}", shell_output(".test")
  end
end