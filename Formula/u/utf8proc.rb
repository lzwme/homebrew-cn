class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://ghfast.top/https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "abfed50b6d4da51345713661370290f4f4747263ee73dc90356299dfc7990c78"
  license all_of: ["MIT", "Unicode-DFS-2015"]
  head "https://github.com/JuliaStrings/utf8proc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "adbb8b5967020e6bcc0589b4a2bfd112c801238f611bd6b591904fd6359a004b"
    sha256 cellar: :any,                 arm64_sequoia: "7d6762b39eb04fea426d4c6656bb596be63f4d1f6f19807aba314a253715d8d8"
    sha256 cellar: :any,                 arm64_sonoma:  "7fd4f73331796506f399a12a7349ad533d0ad27bf261a08e9c1d88dd41922249"
    sha256 cellar: :any,                 sonoma:        "b637585a34b76179c02b738f88b137571663a2044978c760e7df6e3a6520df18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a3f276f2a44273b4948df2416761a1cf996fbac0a168af4f4d11b947e58c655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2faa88cd8a625700d288ae4b89b3913273a0de36ef941a990b7f2fe242cf00e"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end