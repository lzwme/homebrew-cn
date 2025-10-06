class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20251005.0.tar.gz"
  version "p6.2.20251005.0"
  sha256 "67be867027ac7451750e93923f15ce305ad814d4971cda8b0dd108a91bec6b0c"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d7dcc079bbf565be240134b060a4ee424174bfcf4f1a2c4a94a70f50b0075f81"
    sha256 cellar: :any,                 arm64_sequoia: "993e9657a17a73f9fff16fd208afeadce287cb6cf3e8e439259a594ce0d8dcd0"
    sha256 cellar: :any,                 arm64_sonoma:  "9c725c2109e9677aea2d401c8631ca64342911b0487a9a8c5d7067c47cb37d5b"
    sha256 cellar: :any,                 sonoma:        "31d56e36f0a4b232ebf4cfb6941ce15162fdd6df0908e2b1860b293641de1f67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf573d96bd120ec5b1b636a7b8d85dafece8929c444503a560c079bb81cfd83e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75e7225ea57137ce9e6d4b8871647fe2690b795cda7080f21a0cc769a2347263"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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