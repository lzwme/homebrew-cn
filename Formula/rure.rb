class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://ghproxy.com/https://github.com/rust-lang/regex/archive/1.8.2.tar.gz"
  sha256 "07c8546cd4989254766a4d16afb99e351fdf17fb97c63f2662cc994ad0b4eb52"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e31f30132488172a0f1dab2fc838021801a30c34a37bb37c8a59c02afa0aba53"
    sha256 cellar: :any,                 arm64_monterey: "1facf50de8cca3367939d77359a4749d0c19a7484b6da00346a6752abd814eab"
    sha256 cellar: :any,                 arm64_big_sur:  "fce316297034d022fed8b9b3b296db5ec8632a2f5a21c594e10dfb799611d0c4"
    sha256 cellar: :any,                 ventura:        "3421ad62f50e9c375fa820f5090e803c624a3f895278369d9c6d429afec30805"
    sha256 cellar: :any,                 monterey:       "f70bd6f5ba78b1505740b1e84ddcc7eb8ff0bc4bd1714efa5472fc80f3e23d0b"
    sha256 cellar: :any,                 big_sur:        "aef0ef53274065b9aaa81b7c867f43fc3649f4596accaf2c0f30ded775f31626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c01d4b9541b6f3fa72dce7e6cb7d4ef85751ce26ad32b5e730b50c282b5a05c1"
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