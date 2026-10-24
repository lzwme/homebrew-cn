class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://ghfast.top/https://github.com/cloudflare/lol-html/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "a5a59c7d7cb6c33c2b001394dd05768f891aa1769b5bc855f62cbc496a782075"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0c71a4937681a55ee818de998fc7c3a5f1b7b3c77a0149d70b01fdaea115aa5c"
    sha256 cellar: :any, arm64_tahoe:       "cdad53288f43c0a418cbd6d200c6d6a755f10e6cee68bd8da64e42a2f233491e"
    sha256 cellar: :any, arm64_sequoia:     "abe68a90ca318f0cae3976b2b24622119a6f150d00a3207d91361e6ab04f91e2"
    sha256 cellar: :any, arm64_linux:       "46237521d9f5c3053a005d6ae6d9954c04dc9d2c3b5e9ee9f8e31b7fd6c1317b"
    sha256 cellar: :any, x86_64_linux:      "e1b920616ee74e97063241a822a2c01ece451ed0394e8874e75396af9fa2d943"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

  deny_network_access!

  def fetch
    cd "c-api" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--locked",
                    "--manifest-path", "c-api/Cargo.toml",
                    "--prefix", prefix, "--libdir", lib
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <lol_html.h>

      int main() {
        lol_html_str_t err = lol_html_take_last_error();
        if (err.data == NULL && err.len == 0) {
          return 0;
        }

        return 1;
      }
    C

    flags = shell_output("pkgconf --cflags --libs lol-html").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end