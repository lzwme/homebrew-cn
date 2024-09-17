class Urlview < Formula
  desc "URL extractorlauncher"
  homepage "https:packages.debian.orgsidmiscurlview"
  # TODO: Consider switching to new Debian maintainer's fork if it is adopted
  # by other repositories as allowed by our documented policy. Alternatively,
  # we could introduce the fork as `urlview-ng` and deprecate this formula.
  url "https:deb.debian.orgdebianpoolmainuurlviewurlview_0.9.orig.tar.gz"
  version "0.9-23.1"
  sha256 "746ff540ccf601645f500ee7743f443caf987d6380e61e5249fc15f7a455ed42"
  license "GPL-2.0-or-later"

  # Since this formula incorporates patches and uses a version like `0.9-21`,
  # this check is open-ended (rather than targeting the .orig.tar.gz file), so
  # we identify patch versions as well.
  livecheck do
    url "https:deb.debian.orgdebianpoolmainuurlview"
    regex(href=.*?urlview[._-]v?(\d+(?:\.\d+)*[a-z]?(?:-\d+(?:\.\d+)*)?)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2a05f008302affc74e6cab2a4fc76d212678746d4d167252e21d0a7f50d49e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ceb55a63116f409bce3870150eda3310cc48f57813c79e6cb6d8a082e9be2eb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cef111adfd85ccdf8ae30eda094940acc688c8454679b3432c2c8b39e54c32ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "3197e439d22f3e5dcbfa8b38f2e73c40f52e89252b3279c3c5d236b6605165be"
    sha256 cellar: :any_skip_relocation, ventura:       "b39f7e2238dbb7ec1e87a121aa48a88bac18b1e269e3a9b84b601ca410260eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb73442a4c8cac047d120ec566f4bbc59ce23b6eece8fdedd67db4bb9832c2dd"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "automake"
  end

  patch do
    url "http:ftp.debian.orgdebianpoolmainuurlviewurlview_0.9-23.1.debian.tar.xz"
    sha256 "bdb3b403b165ff1fe7d1a7c05275b6c865e4740d9ed46fd9c81495be1fbe2b9f"
    apply "patchesdebian.patch",
          "patchesFix-warning-about-implicit-declaration-of-function.patch",
          "patchesinvoke-AM_INIT_AUTOMAKE-with-foreign.patch",
          "patchesLink-against-libncursesw-setlocale-LC_ALL.patch",
          "patchesAllow-dumping-URLs-to-stdout.patch"
  end

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    man1.mkpath

    url_handler = OS.mac? ? "open" : etc"urlviewurl_handler.sh"
    inreplace "urlview.man", "etcurlviewurl_handler.sh", url_handler
    inreplace "urlview.c",
      '#define DEFAULT_COMMAND "etcurlviewurl_handler.sh %s"',
      %Q(#define DEFAULT_COMMAND "#{url_handler} %s")

    unless OS.mac?
      touch("NEWS") # autoreconf will fail if this file does not exist
      system "autoreconf", "-i"

      # Disable use of librx, since it is not needed on Linux.
      ENV["CFLAGS"] = "-DHAVE_REGEX_H"
      (etc"urlview").install "url_handler.sh"
    end

    system ".configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    (testpath"test.txt").write <<~EOS
      https:github.comHomebrew
    EOS
    PTY.spawn("urlview test.txt") do |_r, w, _pid|
      sleep 1
      w.write("\cD")
    end
  end
end