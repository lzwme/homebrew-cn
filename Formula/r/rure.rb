class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://ghproxy.com/https://github.com/rust-lang/regex/archive/1.9.6.tar.gz"
  sha256 "3510396bf539cc9326824990bc6f24764742db740e84045fd7ec8654aee5980f"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5f671feda9e5afc572d3a557ca098a2e9cd2d9d7be736320a8e070dc1e526513"
    sha256 cellar: :any,                 arm64_ventura:  "62cfda5f175dcbf8a712a52894257544700b7478c1a407e6a4a0370e7933b718"
    sha256 cellar: :any,                 arm64_monterey: "538ec208fe5276d85746bbbd2dee9813cb4a6fa1f717eec31eb8aa649575a323"
    sha256 cellar: :any,                 sonoma:         "d1d91844f853ef0ca86df0539311cfe6d1347b91b0dce0d0c952b20f6221d353"
    sha256 cellar: :any,                 ventura:        "0ea45c1bc8c9d614a596b70f19204677e94fb6fc8821c2a5a12292f6be2563a6"
    sha256 cellar: :any,                 monterey:       "2c162da9155f8a496a09c3c61c3240f87d7aa671940f1055327b92cd21ca8085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a27740e02de49f5bcad3df1e00e6e756f929918ed05275588dca7f8588c12cb"
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