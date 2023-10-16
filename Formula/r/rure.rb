class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://ghproxy.com/https://github.com/rust-lang/regex/archive/1.10.1.tar.gz"
  sha256 "5c74c089710d1f0639d5667efa698c758b07c8219c8d864ba60f41462df361d7"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8bee231d9700c94fe1771c8c4e56b982d13d3d79b3da1500623ef85011ea659c"
    sha256 cellar: :any,                 arm64_ventura:  "aeb366587bbeae20609e7eb58213e8bf43409543322e04d08d1f31a7df5d9cb1"
    sha256 cellar: :any,                 arm64_monterey: "1bebc82243b1e59c386c4b890b86bf81fc14bdc91d675ad428166291e891c44c"
    sha256 cellar: :any,                 sonoma:         "d1533739602747adfa7821841acfdced023ba3b3c9a3a33abb5f56f55571135f"
    sha256 cellar: :any,                 ventura:        "ae81a540966bcd8b75507424de6ad7f7f04d2ab00a5228c46c63ea8fc218ddc8"
    sha256 cellar: :any,                 monterey:       "b1b218610554d64da59c1f75f12941ebfd92b5c8cfd587ed4033eaec3b7ed5ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc48d1348ebeb5d741c1cc51b96e9b377ec2bee1c6c971ee05670647a40b4066"
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