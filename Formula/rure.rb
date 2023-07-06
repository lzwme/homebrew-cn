class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://ghproxy.com/https://github.com/rust-lang/regex/archive/1.9.0.tar.gz"
  sha256 "9d5641dc8525abfca0b8ffad2b19fc9992f9ca169fd250f04ecacde29bfd9402"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e835c4f2e4a07f09f7f400b2b0b017edc570b1fd08155bcd7c67dcd0821df1b5"
    sha256 cellar: :any,                 arm64_monterey: "f0119a85680dc0166e4d05375828a3991f875aa29775c820c6aea3e1c3a32127"
    sha256 cellar: :any,                 arm64_big_sur:  "4ac084dfc920e89a561f838dad652e9c30b53032180521b4fcfcdd759d019937"
    sha256 cellar: :any,                 ventura:        "2e476f59c422790961c9142bc1a8793f9c158c0edfc4cc2148216794b2b26e30"
    sha256 cellar: :any,                 monterey:       "91e8b21b547b066bd4772af34c815213cb8fc24525b8bc7e85ed2ebdadc94818"
    sha256 cellar: :any,                 big_sur:        "c56cb411f63cb8d6fbf8b820a4710fce0d71c63ddc9f117f917c95b6ee1b01c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "889c063c85b3665acafe2be3e10547c3475c05bcde85bea45f35e68dc1b1928a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--lib", "--manifest-path", "regex-capi/Cargo.toml", "--release"
    include.install "regex-capi/include/rure.h"
    lib.install "target/release/#{shared_library("librure")}"
    lib.install "target/release/librure.a"
    prefix.install "regex-capi/README.md" => "README-capi.md"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rure.h>
      int main(int argc, char **argv) {
        rure *re = rure_compile_must("a");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrure", "-o", "test"
    system "./test"
  end
end