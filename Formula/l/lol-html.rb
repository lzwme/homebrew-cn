class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://ghfast.top/https://github.com/cloudflare/lol-html/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "154cbe8e2a27ae5f1014f712c5f192621ce1f142ba2e1e369c6801a07b9bb19e"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7517ed962bb6167a9ea9ddf812b8cbb485d766eb61b09bb90bf38e2ca30cc83c"
    sha256 cellar: :any,                 arm64_sequoia: "5f807653830c3b7d3fd3a4a78ec4fff4a82791eecff8ad17e44bb208a6b09bb2"
    sha256 cellar: :any,                 arm64_sonoma:  "cf11e71d2e93bcc118e0c56093c50cb52677b92adfb6bb0af68c81e2c34f9302"
    sha256 cellar: :any,                 sonoma:        "29cdaf5c902675db95894b3456782b4ec51d4a5abcb51dbc035f57ed24273d62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "947d9d4859883980005abe4f441992b052672715867f580771f50acf453da62a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df33145b452fdcfb3b5192fb3dfed0b6fea383558d066228b6bd4a99ee5b7b93"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

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