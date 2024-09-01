class Libnghttp2 < Formula
  desc "HTTP2 C Library"
  homepage "https:nghttp2.org"
  url "https:github.comnghttp2nghttp2releasesdownloadv1.63.0nghttp2-1.63.0.tar.gz"
  mirror "http:fresh-center.netlinuxwwwnghttp2-1.63.0.tar.gz"
  mirror "http:fresh-center.netlinuxwwwlegacynghttp2-1.63.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https:github.comHomebrewhomebrew-corepull133078#discussion_r1221941917
  sha256 "9318a2cc00238f5dd6546212109fb833f977661321a2087f03034e25444d3dbb"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d8295aef078f83d3a316d20cb8feae89bb8cd84bbb53b3c3b66dd178aa92101"
    sha256 cellar: :any,                 arm64_ventura:  "565d7dbdb9108d0bcf0ce8aa47bee5d508107cc8c369db77091450aebdcc449a"
    sha256 cellar: :any,                 arm64_monterey: "8464820d193c65e2ebf18751cee6dda918ec6a2d8323560248cc8b1984b3a66f"
    sha256 cellar: :any,                 sonoma:         "6abd774863aed37534c322e3d87c6676970478384b80fe04b1587b4e4ea29ba3"
    sha256 cellar: :any,                 ventura:        "f29d667c9dc0f9898bcd889c29c8b1b1384128cc4640a8a657d622570b8aaa1d"
    sha256 cellar: :any,                 monterey:       "7cd2fd7fe202c679aadf5a2318e97d464bef03c23dbc24fc2f9d5cb6b1628d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b72e73226c370de2ba1680f11e0ac5f69bd64235756c5bea5a7dbaffc48a6ea2"
  end

  head do
    url "https:github.comnghttp2nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  # These used to live in `nghttp2`.
  link_overwrite "includenghttp2"
  link_overwrite "liblibnghttp2.a"
  link_overwrite "liblibnghttp2.dylib"
  link_overwrite "liblibnghttp2.14.dylib"
  link_overwrite "liblibnghttp2.so"
  link_overwrite "liblibnghttp2.so.14"
  link_overwrite "libpkgconfiglibnghttp2.pc"

  def install
    system "autoreconf", "-ivf" if build.head?
    system ".configure", *std_configure_args, "--enable-lib-only"
    system "make", "-C", "lib"
    system "make", "-C", "lib", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <nghttp2nghttp2.h>
      #include <stdio.h>

      int main() {
        nghttp2_info *info = nghttp2_version(0);
        printf("%s", info->version_str);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnghttp2", "-o", "test"
    assert_equal version.to_s, shell_output(".test")
  end
end