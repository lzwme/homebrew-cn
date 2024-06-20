class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https:github.comadrianlopezrochefdupes"
  url "https:github.comadrianlopezrochefdupesreleasesdownloadv2.3.1fdupes-2.3.1.tar.gz"
  sha256 "2482b4b8c931bd17cea21f4c27fa4747b877523029d57f794a2b48e6c378db17"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "65f17f8d9c31f7ee3648b6a0c5bfac4754e25b6aea496b28417440947241582d"
    sha256 cellar: :any,                 arm64_ventura:  "bb6b0a19e34f6230fd76ad8761e5dba4ba3a16faa3fcc393f4b75398cc919161"
    sha256 cellar: :any,                 arm64_monterey: "151f717254451ebbb476565823cba0f4f709cb35009082f44682d79b78ef2c57"
    sha256 cellar: :any,                 sonoma:         "b8d98cf9158e8111a8365311ecd94358ce20f19f23f7ff569362ea856f74a0e9"
    sha256 cellar: :any,                 ventura:        "274cd9cbf56ba61fd0528b2e3549fae90455108a25199545b603331a56e974cd"
    sha256 cellar: :any,                 monterey:       "c88cd4de051a3af80647bf1bf3a96f3b2f8878e9c898e601f21ce256845428f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbe6123f86521aa400f2cd44afca040e620e3504a1a0ff24ed43c3ef73504fcf"
  end

  depends_on "pcre2"

  uses_from_macos "ncurses"
  uses_from_macos "sqlite"

  def install
    system ".configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make"
    system "make", "install"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}fdupes .").strip.split("\n").sort
    assert_equal [".a", ".b"], dupes
  end
end