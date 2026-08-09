class Libultrahdr < Formula
  desc "Reference codec for the Ultra HDR format"
  homepage "https://developer.android.com/media/platform/hdr-image-format"
  url "https://ghfast.top/https://github.com/google/libultrahdr/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "5e422540271b64473d069623136e207d0516999aac2f819fb6176a01a3f9f915"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bbfda15ba439949f899fbda932315d020bb8b302a35626d3653d280f610968ab"
    sha256 cellar: :any, arm64_sequoia: "d66af7dedb5f7ab99726fdd28fd987e59927e919c32575411a518e97e16e7013"
    sha256 cellar: :any, arm64_sonoma:  "53d1457c1cf34497c131f20bb38ae704f830ea15f4cfcbdc22d0a079a00589f2"
    sha256 cellar: :any, sonoma:        "0b6771e28316662180a0a242d44fe63ca985a60bf19eb271c172604d8411275b"
    sha256 cellar: :any, arm64_linux:   "f0826e58949cba2fb4588bcc7016573023445a8d65aa519216eaf50b72b2c4be"
    sha256 cellar: :any, x86_64_linux:  "267677d00d922dc6212cbd8d4567123703db93ea494723996aab36ae39785480"
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