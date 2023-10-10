class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://ghproxy.com/https://github.com/rust-lang/regex/archive/1.10.0.tar.gz"
  sha256 "1ef71759ce6177fd403d76019a4c1d816eb1bd64c3972bab1712f5b01667f007"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7dc70c8d91426cbfe97a53b086a2031e4f266f7cb423aa6ea5b187ef4725325e"
    sha256 cellar: :any,                 arm64_ventura:  "ee3c75d973290b7d0abae30c94381553b9e9d5e00aa86417c9681d4566fe285b"
    sha256 cellar: :any,                 arm64_monterey: "033ba1631ef09b633a7b3ab2e6395bfebb83fd96f808c35fda1c58d99bca86a2"
    sha256 cellar: :any,                 sonoma:         "8a89e33d0b48c0da3f7fa8c4ccc817adea282d7f130e9dd74b219c507981a106"
    sha256 cellar: :any,                 ventura:        "9b0bcda6f55fc169b79147ca7794dee553d8a3f018ba77ebe41cdd571a7f2c4f"
    sha256 cellar: :any,                 monterey:       "f465d13a144cda4403d1eff1e1a3de828b9ec88ee27a166fb31e811338c8749b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ad271e4f9520331eb0e8a411041ad7f70f9d677c19cb20cff3151a7dd5a7373"
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