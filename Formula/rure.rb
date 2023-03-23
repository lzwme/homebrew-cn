class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://ghproxy.com/https://github.com/rust-lang/regex/archive/1.7.2.tar.gz"
  sha256 "e929a68627e698d60c755f3a50c49c364c1fe7d98f8e1236c94d79e34b5e4530"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c0935616a679575d95d5ec7b1e050480ffae0d59b17846beed0bff2cf873e77b"
    sha256 cellar: :any,                 arm64_monterey: "07f07b80a531485ebad1dcb406564f481ba8a1e78676f08f85e635b7e4162ecd"
    sha256 cellar: :any,                 arm64_big_sur:  "27720ae07b2f567bdce817e0870a72af3858f47d404dec2531fcf1743857eff1"
    sha256 cellar: :any,                 ventura:        "842cc73e03e8a0f8327fd3536ee12abc15b23cbe068f99cff3eee0fcdee09022"
    sha256 cellar: :any,                 monterey:       "ab379f29cac467b858ed52c08dfcb037efe7c6807ebdf05692270231ebbf130c"
    sha256 cellar: :any,                 big_sur:        "066798feb5ead8c986951d82a199aa53c4efde0ecdb50b0746b523412fe24cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "732b9e2cd7e64f94a21a80c472f119b4eb156c798f3f5dd25b4138c56e0a1b5b"
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