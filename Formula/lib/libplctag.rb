class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://ghfast.top/https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.6.tar.gz"
  sha256 "88cb2b6b3953c90de00efcd4d841f42aee1f30408f47e612d48956d9d473dc71"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "649b428894a72c35bec7f50329d484632bd02e1cb73de48185210f4954a7b789"
    sha256 cellar: :any,                 arm64_sonoma:  "b2c3a7365c91b587d01dfeba2fd0dd08271e586be820b0a15d7b44bc5954a87b"
    sha256 cellar: :any,                 arm64_ventura: "e6ac88053708bf30f82db2e67d53f323ac0b89fe49d77be9bfa4faf202257ca1"
    sha256 cellar: :any,                 sonoma:        "d5635aec1a30c1d5a435891e88ab9f60169621dd2db0c9e4d3568b12503c8741"
    sha256 cellar: :any,                 ventura:       "2296e8a8c74c25fcd29dca1fc3a0e615183738028b2f471cd98dcc101c4476ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce65367b15e676b37e1b64bb260fc9892613ede4141d4989a79ce7e09363027f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab90d8173713fada68ec35bf3eb92ac8ed5f107c8700ba5c80edcaa9f6bd0b44"
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