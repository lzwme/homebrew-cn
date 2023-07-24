class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230723.0.tar.gz"
  version "p6.0.20230723.0"
  sha256 "daecce9a9d143571490785991ae769c43c8566b46d09830d507541f7bee253a1"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cf9218d6a767f1dfaf8457bbae6a48b3fa5d18c2267e946c78b8cb742330907"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b9ece497a338a06d20a2bc5b41b6b05040fbee29273bdc477ccd5b2de969bd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a31d5fcff14d724208068c22a80955cb3a058172797bbff0de0bca500592dc03"
    sha256 cellar: :any_skip_relocation, ventura:        "1e350fa0d01a980e98cd8e7c5dc240ac4ef60e735d7fcb6732ff46b2dc5d15ef"
    sha256 cellar: :any_skip_relocation, monterey:       "4fe05b2714f383f0092dcd1237d78dee1277ad06804e83f18d3c3e2bb03b9949"
    sha256 cellar: :any_skip_relocation, big_sur:        "4740f3a865060a4880626701099874801d2b8270d24b61ff5ea38925c7e865a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3a119b5d89ddba963d40868486debefdd5e3feedf90bb317fbf6e245efe2a4e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end