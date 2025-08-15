class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://ghfast.top/https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.10.tar.gz"
  sha256 "3de61c3802fcc3b9b80fb818d5e20bd4168b5a9fb30e76317c27174343bd5dfa"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05bd9c99322d0136fe0c21f40596eaf4dc9c6fe60276ec248ae04126831dd77d"
    sha256 cellar: :any,                 arm64_sonoma:  "78ce89a44c82d5f5c596f0edc67fe8139530066d0af06f605df4801dc5776677"
    sha256 cellar: :any,                 arm64_ventura: "856e789206591766a8d25c6e312d5937cc1565c4a83de4f12c9ebd8c02c4d441"
    sha256 cellar: :any,                 sonoma:        "c5f9e294b69f241c01317be7934a7ca3d9aa2c6e80664de3bbb3b17d11607967"
    sha256 cellar: :any,                 ventura:       "99d85721b3a4294a77bd9618573259a6469d6a24b5b0228e042e3d974a375714"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5229047a512f84492f6b776daa33e233a46b1ee464f6ca5b4310f92cc9548305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d5fecdd2dcf2865414a42da77f841581c6ab58102cedfe9bab3a5e3a25d248a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        int32_t tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray", 1);
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end