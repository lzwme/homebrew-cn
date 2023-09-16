class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230910.0.tar.gz"
  version "p6.0.20230910.0"
  sha256 "4436ebdeefc6089380655ccc4ca1d97d9662478b7b0ce3269564ea46c65d18dd"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9af90e75a03f5ae29d2cc947c76b98e79a46117887a6eb3be15092f5d30a496f"
    sha256 cellar: :any,                 arm64_ventura:  "fe2dcf4b01cec99cef5c93bf2b1f7816410ddab83a13e443e1327cac792ffeb2"
    sha256 cellar: :any,                 arm64_monterey: "673098c6985c91d35be6f74c26a59dc3c93ed05b1ca6763288a01501da10eda9"
    sha256 cellar: :any,                 arm64_big_sur:  "6f26b0d4639cf15a7c1ad452f5e6f869432bc649e4f46886b79f7e9eadbd4a6f"
    sha256 cellar: :any,                 sonoma:         "2f516e6debf02087ad8f0f5e614e317309df172b73435b205e4579d15962a156"
    sha256 cellar: :any,                 ventura:        "ef3599126c2ecf196dec5643190ed68a07e6ac61d0e966c35d7cfcf8cb0ac371"
    sha256 cellar: :any,                 monterey:       "e2c24a5281b601935f467cdf9e9deea569314799a724b884dbf2ea8570c9da34"
    sha256 cellar: :any,                 big_sur:        "beb771be00c4081f8c8d1a273c6c79c0c5208e34a600ad9f737a45f7736b32e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fed53ea731bdf685e9ec2b986c8ef4eaf75ff3e229707d8b1dfca9ff91a4abc8"
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