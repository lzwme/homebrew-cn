class LolHtml < Formula
  desc "Low output latency streaming HTML parserrewriter with CSS selector-based API"
  homepage "https:github.comcloudflarelol-html"
  url "https:github.comcloudflarelol-htmlarchiverefstagsv2.2.0.tar.gz"
  sha256 "4c5fe6a8497b1ced1b6db8d9fb16c934375b1f02f69db765713f6bd367719e65"
  license "BSD-3-Clause"
  head "https:github.comcloudflarelol-html.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9531636cc6ee9771e763c277cbac1a8a59677817602ba2042e009a193762ff3b"
    sha256 cellar: :any,                 arm64_sonoma:  "26f518582c917b12c87513e30c8c475d587f47e2577a53fcea5ecd174f454ca7"
    sha256 cellar: :any,                 arm64_ventura: "529459d66560903b289b15eb8ba951c973a11bd40c80f8a99205f566f3b4fae2"
    sha256 cellar: :any,                 sonoma:        "9de53bf6bca25ba74ab51032380b6bb35a677a1ca776d63ca69e0a7217b1896d"
    sha256 cellar: :any,                 ventura:       "b94d90fb506a5346cf8116a1967964d29c340717052a6435a6629382fe62f0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2b1c0c0004fa4d21f5e7149e28aff9175711bc63cc4c71af6c72279cb4cfd1"
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