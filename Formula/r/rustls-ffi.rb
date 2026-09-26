class RustlsFfi < Formula
  desc "FFI bindings for the rustls TLS library"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://ghfast.top/https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "f9d7416a0e8a3678e4192244639ab0a5cadfd12802001dc1c43491a27f12d1bc"
  license any_of: ["Apache-2.0", "MIT", "ISC"]
  head "https://github.com/rustls/rustls-ffi.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "66a0039980bb6e8e77c059d4212c18414bb951c27cea4a159b1ecfede81e2707"
    sha256 cellar: :any, arm64_tahoe:       "da40e0fde571c01831130d4d737de97cd2b4cc352fee2a6530f9cfeab14f37e7"
    sha256 cellar: :any, arm64_sequoia:     "cbb342b73592ef2727b60a642cf1820e953072437d1f3753ed845ab80586b943"
    sha256 cellar: :any, arm64_linux:       "de05c90cdd1963dccc514df6e3b77a3bb4c2acbf038f7d2ce76000dccc3e4c4a"
    sha256 cellar: :any, x86_64_linux:      "0f2e2eaaabec051b2a9ebcb43b93fa0879fd698b48b4e4eb6f69495beecac7d3"
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