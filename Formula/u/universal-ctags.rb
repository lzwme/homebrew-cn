class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20251109.0.tar.gz"
  version "p6.2.20251109.0"
  sha256 "79db0035d2437079bb0bf10d62a202d352d7cf962f5f4f756239468d7df7c425"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6c8c4f5657d69b649c3f66adf07f978836dd342e3d866b76fcf72c8107e82a7"
    sha256 cellar: :any,                 arm64_sequoia: "099fed2ef91b15a12dab03eb423938e444e808425930799b4f69aa31eb0f5982"
    sha256 cellar: :any,                 arm64_sonoma:  "d4dc53c366b04f68b4483b40c7716487f33b26a04da9692dadeae15ac13976a6"
    sha256 cellar: :any,                 sonoma:        "d823a3d7b5e839679b116584a481aca4a75e97013c6b966b6e26e0b115bd1f2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db556508d739a5187392615e950486d103d6a53cb76ad62d71164c9c6f78a0ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dc46550623ed631cb9b5bb1da3dfb4505b7f9d716b9221ddf0b8d5079ea4f0a"
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