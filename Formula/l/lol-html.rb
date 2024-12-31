class LolHtml < Formula
  desc "Low output latency streaming HTML parserrewriter with CSS selector-based API"
  homepage "https:github.comcloudflarelol-html"
  url "https:github.comcloudflarelol-htmlarchiverefstagsv2.1.0.tar.gz"
  sha256 "fbc4eefbffb570f92d1133f092d93a5d2b993777e00bb4f612c17ac79a6e021b"
  license "BSD-3-Clause"
  head "https:github.comcloudflarelol-html.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ef081850ef8f28e018b65c4b7dfe9e0ec2c79c7177529d4117cfe05ecf1d429"
    sha256 cellar: :any,                 arm64_sonoma:  "4d10b3710768cac73e457cae0a22eae41eb18d52440bf405401bd4f5a3531ebf"
    sha256 cellar: :any,                 arm64_ventura: "5ccd12f21cf76ba28e902f6f5cd18cfb4b072dfa685a61c776a88daac7e541e4"
    sha256 cellar: :any,                 sonoma:        "80e300bf2b95d7ce03a414eb8f287e6977863d1fe1337022b37a6b4da17a4527"
    sha256 cellar: :any,                 ventura:       "96abc43b365ea6af2e29a102ec783001a8b926a642c93d1741960e1bfa5cfac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cbc32ec855ef188329a705f0ee009275657e4abd0f038b123b24ea6c4bf65cd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--locked", "--lib", "--manifest-path", "c-apiCargo.toml", "--release"
    include.install "c-apiincludelol_html.h"
    lib.install "c-apitargetrelease#{shared_library("liblolhtml")}", "c-apitargetreleaseliblolhtml.a"
  end

  test do
    (testpath"test.c").write <<~C
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

    system ENV.cc, "test.c", "-L#{lib}", "-llolhtml", "-o", "test"
    system ".test"
  end
end