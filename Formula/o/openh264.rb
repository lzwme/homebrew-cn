class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://ghproxy.com/https://github.com/cisco/openh264/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "a44d1ccc348a790f9a272bba2d1c2eb9a9bbd0302e4e9b655d709e1c32f92691"
  license "BSD-2-Clause"
  head "https://github.com/cisco/openh264.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79a53414d694747723a7a5ab644a7f259f2e84d341a8b0c2cc3188b2755cabf5"
    sha256 cellar: :any,                 arm64_ventura:  "97c85fabc1c38d1a32262d63756d321b6110739464c0967543fcacb92c0210f0"
    sha256 cellar: :any,                 arm64_monterey: "79860fa499ecca3980ba2c2fccffe20687be3fbc5894306ac37fd602f0df3793"
    sha256 cellar: :any,                 sonoma:         "0c00c6a6dbf644f6b90a21c355f1805855f5d17818fe7b9d865b8269611136a4"
    sha256 cellar: :any,                 ventura:        "740c0ced89df180ea45ad46a9c9d65137d097739e36400d465a653f250e292e8"
    sha256 cellar: :any,                 monterey:       "18adc11e0b6efad17e3dc546119f90873dc5ef1ca5ae0f708e217b4ccfeb6561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c318c6e7e68e0a784243662ffcd6f488bf702a560b4d7248d7c04f5ccd9add0"
  end

  depends_on "nasm" => :build

  def install
    system "make", "install-shared", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <wels/codec_api.h>
      int main() {
        ISVCDecoder *dec;
        WelsCreateDecoder (&dec);
        WelsDestroyDecoder (dec);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lopenh264", "-o", "test"
    system "./test"
  end
end