class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://ghfast.top/https://github.com/nghttp2/nghttp2/releases/download/v1.67.0/nghttp2-1.67.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.67.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.67.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "f61f8b38c0582466da9daa1adcba608e1529e483de6b5b2fbe8a5001d41db80c"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6fcef884a53969c9b3e31a8c760553b1c7d7435484eb3231b6d472105498bb6"
    sha256 cellar: :any,                 arm64_sequoia: "35b1d5add253624e9a904dfe1e3f1145d1d7acc7618d6f9ea7ac312f878be442"
    sha256 cellar: :any,                 arm64_sonoma:  "7eaeb92466cb3d228cd785640ad5cbebc18d6747dc80b62a643735a2a80d80b1"
    sha256 cellar: :any,                 arm64_ventura: "db741bfc1b3aa98d58bdafb3a885afddbb2b37e4f1331bf13f93cd31d5143768"
    sha256 cellar: :any,                 sonoma:        "173a251c48ebb608372ecbebd224d4db0e7fc7150eb6ee432e1cd68ce19e4c62"
    sha256 cellar: :any,                 ventura:       "715ed01be25c8688ee2c2c11cc24150b2183f4b9bde0a68c69a49a5c1738b958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce92dde5854bd7953bcd79eeb62f82e686db332ed6c9a8c52f9b7c67e36c9b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "767cc1b1202503f66328441fd7c75b6978359269b2386c4203be85f50bbe5da0"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  # These used to live in `nghttp2`.
  link_overwrite "include/nghttp2"
  link_overwrite "lib/libnghttp2.a"
  link_overwrite "lib/libnghttp2.dylib"
  link_overwrite "lib/libnghttp2.14.dylib"
  link_overwrite "lib/libnghttp2.so"
  link_overwrite "lib/libnghttp2.so.14"
  link_overwrite "lib/pkgconfig/libnghttp2.pc"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--enable-lib-only", *std_configure_args
    system "make", "-C", "lib"
    system "make", "-C", "lib", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nghttp2/nghttp2.h>
      #include <stdio.h>

      int main() {
        nghttp2_info *info = nghttp2_version(0);
        printf("%s", info->version_str);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnghttp2", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end