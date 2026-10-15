class RustlsFfi < Formula
  desc "FFI bindings for the rustls TLS library"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://ghfast.top/https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "5be0a6abd612e067349f6f4f1469672685a582d40c1469c28662edceb9273786"
  license any_of: ["Apache-2.0", "MIT", "ISC"]
  head "https://github.com/rustls/rustls-ffi.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d77b855984a2a6212adf72bc57afdd1bc5c8ad98a0843a3335dad943cb1681e5"
    sha256 cellar: :any, arm64_tahoe:       "ca4cd868b48d6b93e8b0125b4bd79165c9f8679797568c866e330608ca5ffb03"
    sha256 cellar: :any, arm64_sequoia:     "530c8c1ac06366e9daebf2d75aeb7c23e5f2f9458ff6231b08ed55a061ecd137"
    sha256 cellar: :any, arm64_linux:       "e914e26815690d13efa0a6032932972da0aafe9516b7b81dad76eb79359c24be"
    sha256 cellar: :any, x86_64_linux:      "12116293fdcf34089f3463472ba5af5adbd313db0b57549a49d2b727b8749045"
  end

  depends_on "cargo-c" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--prefix", prefix, "--libdir", lib
  end

  test do
    (testpath/"test-rustls.c").write <<~C
      #include "rustls.h"
      #include <stdio.h>
      int main(void) {
        struct rustls_str version = rustls_version();
        printf("%s", version.data);
        return 0;
      }
    C

    ENV.append_to_cflags "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-lrustls"

    system "make", "test-rustls"
    assert_match version.to_s, shell_output("./test-rustls")
  end
end