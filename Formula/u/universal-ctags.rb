class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20251026.0.tar.gz"
  version "p6.2.20251026.0"
  sha256 "e13dc813e328c9e107293f3a0fbd546b4da8afdb139e18173cf08e99a5fdc26f"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea7b95d67bbece1c75474f6aea76291c40ae04a1550da7958852a78029d5b322"
    sha256 cellar: :any,                 arm64_sequoia: "0e65ff524e557891dd724195acbfdc8dc6312e01ae16fffa58bf3cd0866d1b10"
    sha256 cellar: :any,                 arm64_sonoma:  "8e01789a7c8c0f225c27540acfb55e3774dcdd032038aa411078a164ec92e1f0"
    sha256 cellar: :any,                 sonoma:        "614e4b321fb10738aef4ecbe4fa27dd7bb92ee186994e7d0a58cec9270d897eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a9f4f6ee70ae82e6323db433fbb41880834a9ecdbb7b1f2456e8768b4e0a17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54e3dd5d3aad44a55705a4a1df2f214e2bfb13a34e3bbfd0bf0daf5b9cfd97b4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "both install `ctags` binaries"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    C
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end