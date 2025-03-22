class Libpinyin < Formula
  desc "Library to deal with pinyin"
  homepage "https:github.comlibpinyinlibpinyin"
  url "https:github.comlibpinyinlibpinyinarchiverefstags2.10.0.tar.gz"
  sha256 "478d98ce15a2ff887fdd183c904dba82c2724f3cb9439f8441c736f0ff293279"
  license "GPL-3.0-or-later"

  # Tags with a 90+ patch are unstable (e.g., the 2.9.91 tag is marked as
  # pre-release on GitHub) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(^v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b8dac5d58d160815c73c53d8fa267cf5ec595d20c99946ab3b0520899a14ef1a"
    sha256 cellar: :any,                 arm64_sonoma:  "7de23fd9ef7c1df08b5d7b5a4fe483d6cc716ecea6159b64959efb0c8c8ff3cb"
    sha256 cellar: :any,                 arm64_ventura: "66cef63e3182ab1cc950f068660ccb82907670e4bf02973f68f9c0abbc637804"
    sha256 cellar: :any,                 sonoma:        "42ac21b0b3d68421af64b543a327303a6055a84d5954b3f5caba3454ad8f840d"
    sha256 cellar: :any,                 ventura:       "9950ba2086c77bad3f506e3bd18a1d98366de65bb676d80815963446a0620bce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1fbbd8e1c8506fa173616da2c2f6d97d74477f9225a86915ec6300f47b42342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ba1959f1051f9d85c55e2eaed3c713e361cc881baa2aefa6c20279e4c08353"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  # macOS `ld64` does not like the `.la` files created during the build.
  # upstream issue report, https:github.comlibpinyinlibpinyinissues158
  depends_on "lld" => :build if DevelopmentTools.clang_build_version >= 1400
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"

  on_macos do
    depends_on "berkeley-db"
    depends_on "gettext"
  end

  on_linux do
    # We use the older Berkeley DB as it is already an indirect dependency
    # (glib -> python@3.y -> berkeley-db@5) and gets linked by default
    depends_on "berkeley-db@5"
  end

  # The language model file is independently maintained by the project owner.
  # To update this resource block, the URL can be found in dataMakefile.am.
  resource "model" do
    url "https:downloads.sourceforge.netlibpinyinmodelsmodel20.text.tar.gz"
    sha256 "59c68e89d43ff85f5a309489499cbcde282d2b04bd91888734884b7defcb1155"
  end

  def install
    # Workaround for Xcode 14 ld.
    if DevelopmentTools.clang_build_version >= 1400
      ENV.append_to_cflags "-fuse-ld=lld"
      # Work around superenv causing ld64.lld: error: -Os: number expected, but got 's'
      ENV.O3
    end

    resource("model").stage buildpath"data"
    system ".autogen.sh", "--enable-libzhuyin=yes", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath"test.cc").write <<~CPP
      #include <pinyin.h>

      int main()
      {
          pinyin_context_t * context = pinyin_init (LIBPINYIN_DATADIR, "");

          if (context == NULL)
              return 1;

          pinyin_instance_t * instance = pinyin_alloc_instance (context);

          if (instance == NULL)
              return 1;

          pinyin_free_instance (instance);

          pinyin_fini (context);

          return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs libpinyin").chomp.split
    system ENV.cxx, "test.cc", "-o", "test", "-DLIBPINYIN_DATADIR=\"#{lib}libpinyindata\"", *flags
    touch "user.conf"
    system ".test"
  end
end