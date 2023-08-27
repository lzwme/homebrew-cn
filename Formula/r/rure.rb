class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://ghproxy.com/https://github.com/rust-lang/regex/archive/1.9.4.tar.gz"
  sha256 "fc904f5ffa83c12eaf19fd8f5826445eecc337f9751fad7128ae7096f8a61372"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d76eed73d37de5a5197c3c69a19d5ee6c8bb629ca0aa55cfa1c66a95ed24c45f"
    sha256 cellar: :any,                 arm64_monterey: "466492c6045b56abfc2e99dae505b3a4b260c8aa41b2b3b5bca3b82d73984381"
    sha256 cellar: :any,                 arm64_big_sur:  "b030d4b3f2e2e3f2d295afc17ee6c087eec55fb783693bcf56156a1bb4b549ec"
    sha256 cellar: :any,                 ventura:        "6a5161262dea7755166ac629858dbc30dbf558aee125783cbc27efff53c23ddf"
    sha256 cellar: :any,                 monterey:       "9f9f8cb3cf94db470b6701e492d87bd0f522eb3b0c926926e6d0575646c04210"
    sha256 cellar: :any,                 big_sur:        "d2b53aad7a05823d53a5fbe576bb65fb90c60d2367ecf5a0fc5463519cdac8bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa89146956e7c3fdbef6cf43fdea106e511f542e7e25b4d77e66cda2b3b39c4c"
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