class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://ghproxy.com/https://github.com/rust-lang/regex/archive/1.8.3.tar.gz"
  sha256 "36074d5a6550590a8cd6b8f71ddaccfd1105c4794a81b59bc196e37bdcd9f0e4"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3692d6f9c1aacb10dbb3c64740e8f8e3c46d7cfb166155a92b997c74f98dfa56"
    sha256 cellar: :any,                 arm64_monterey: "024c66fc175aa057c885e85faf074e0eb58b2ab7a83cd1ba36f69d1ca0e96832"
    sha256 cellar: :any,                 arm64_big_sur:  "05e026fe482b1d810b3e43ec9326be14ddccdf6d00c4bb34d3b85928e46f996e"
    sha256 cellar: :any,                 ventura:        "d93d01801c4302b2a7369eab89287bcf892bfb4e828491415892e915674cd4cb"
    sha256 cellar: :any,                 monterey:       "4559ef4ef13cbdfa3a38a2a8d6b9400123974994671f540f76d519784ba3ebd5"
    sha256 cellar: :any,                 big_sur:        "b8cdc3ce259a1a5d731acc635e84bd9a43b80b941666736fda482f19109f2934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c240f6f0fda82f14b4499fe05037ddbd7ba14e8203602ab9ce94e716a4b4ae64"
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