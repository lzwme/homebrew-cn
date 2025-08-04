class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20250803.0.tar.gz"
  version "p6.2.20250803.0"
  sha256 "62927945f5bab945aa1a4ae539d12bf403c992067ea30d9e50863666b4c33b6a"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3e10751497f98b8e7aecab44b4043d80c8bc4a6d741400f03006ba6881c8f5f"
    sha256 cellar: :any,                 arm64_sonoma:  "7726fda084cda9aa85f0e18304ba1c7bd54b0585e65cd95008db3f56eed1391b"
    sha256 cellar: :any,                 arm64_ventura: "a150d0188e2171905279875e3cffa428cfe5478bf446fe2ed5757a391e739951"
    sha256 cellar: :any,                 sonoma:        "2e23309a6644211d070ff13b450a47526b31f498fede8140f8ac7c2e889cb731"
    sha256 cellar: :any,                 ventura:       "5318a695cd39f639e8a794f1f714634654a086bad25dbafa233d8b208a8a2492"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "077bef881e51a27813f082cb385403547280c03fe28eb89db569c33853a11e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d886ffc50a8369cd5f6ef821ff793117cb5b8ce1f24414445573f977817e707"
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

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

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