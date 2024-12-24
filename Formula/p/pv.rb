class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.9.25.tar.gz"
  sha256 "162495aabb1cb842186cb224995e3d5f60a9f527a49ccbd8212383cc72b7c36c"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "e0da19b94f65cb3443073d84dc56636fc17122537f222cc74eb8526872036685"
    sha256 arm64_sonoma:  "5cb01ad3f5394b602152c5a8501e778dc72005e9fe0aacfeb7924a5309c702cc"
    sha256 arm64_ventura: "c57e295e51a38b43d01acdb12b546551b2a7dc2234fa51e3452ea0a8df48a910"
    sha256 sonoma:        "e336a400640f881823b2aeb1cddadcd5cdadcee1d70d95d140c628b49cfde3cf"
    sha256 ventura:       "9495bf894c4d9265c399544d8e7c8a84fbd1d570fd06193b8e969c3036d6706b"
    sha256 x86_64_linux:  "9df26dd6d6cbc6753eb33552a2bc28bd6587aa2875bf3edacd1c279fe824cfbc"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end