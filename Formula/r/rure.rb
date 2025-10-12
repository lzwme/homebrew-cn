class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://ghfast.top/https://github.com/rust-lang/regex/archive/refs/tags/1.12.1.tar.gz"
  sha256 "f767fa18691ed2a8cf140fb793f792f3f17acbe87ec4ddaf44ae72800607579f"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "baff65e34d26f5ae9b23754fe045e58ed24737850ef554b81560dec0ff8ae2eb"
    sha256 cellar: :any,                 arm64_sequoia: "da176e1e2773c2553101ec252d797debfb4c284839ba9dbec4ac3e5580c12b34"
    sha256 cellar: :any,                 arm64_sonoma:  "5757f5da308e85edabee9ee5aea7a6346d772db4bf56ad4daf14863f97e94a45"
    sha256 cellar: :any,                 sonoma:        "5c40e28faa86bc59e44f61177085a27ee31c1462c47edfdb99a45336b3168b17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80c8482dae7b075343c4c7cbc4edcf179121512edcfc812b728366d43b3823be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c393ecc854213ee61f40955d3ad1d38dd54805507f3fa49c2d5a27c97fa35c3f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--manifest-path", "regex-capi/Cargo.toml", "--release"
    include.install "regex-capi/include/rure.h"
    lib.install "target/release/#{shared_library("librure")}"
    lib.install "target/release/librure.a"
    prefix.install "regex-capi/README.md" => "README-capi.md"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <rure.h>
      int main(int argc, char **argv) {
        rure *re = rure_compile_must("a");
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lrure", "-o", "test"
    system "./test"
  end
end