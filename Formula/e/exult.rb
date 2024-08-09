class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https:exult.sourceforge.io"
  url "https:github.comexultexultarchiverefstagsv1.8.tar.gz"
  sha256 "dae6b7b08925d3db1dda3aca612bdc08d934ca04de817a008f305320e667faf9"
  license "GPL-2.0-or-later"
  head "https:github.comexultexult.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sonoma:   "f2cc3026130dc563675724c1ccff8a16005d53ea2c1de7d59e3d164c1fa3958e"
    sha256                               arm64_ventura:  "0a7fc1d5718a8254b8adf9b7783ac85baa404d8bec3e7b490b2d7a46bb153802"
    sha256                               arm64_monterey: "28380485157dd2a521e9c72ff3baa1f1e392694f636697478606c89eb7f0e179"
    sha256                               arm64_big_sur:  "1ac2db0c3d8b26091435336777f22f72594b0474bdd4d13092886f4630a87479"
    sha256                               sonoma:         "0a539d1b0bba11927ecd5963e096ba9c464ef09d7ea72a8173ee5b8e36941a88"
    sha256                               ventura:        "b08b50df709734a618a49622be3e968aff067ef1be742190c355204b30c4a98a"
    sha256                               monterey:       "5202bc6cd443aadfb76b48c6734f03b15c0b20d3cc13eeb7ff90e0233997ce73"
    sha256                               big_sur:        "21159eb863130508a83690868d84c499789c12d4e84594a6156846074e97ef0d"
    sha256                               catalina:       "fc44b27ff30145ab9647dd2336513a376fee5e2884c354697a98925b324788c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8576be4d556f2f557252d541fd91efc5ca46e7d526cf014ba1a5a87d0a5a239b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"

  uses_from_macos "zlib"

  def install
    system ".autogen.sh"

    system ".configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "EXULT_DATADIR=#{pkgshare}data"

    if OS.mac?
      system "make", "bundle"
      pkgshare.install "Exult.appContentsResourcesdata"
      prefix.install "Exult.app"
      bin.write_exec_script prefix"Exult.appContentsMacOSexult"
    else
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      This formula only includes the game engine; you will need to supply your own
      own legal copy of the Ultima 7 game files for the software to fully function.

      Update audio settings accordingly with configuration file:
        ~LibraryPreferencesexult.cfg

        To use CoreAudio, set `driver` to `CoreAudio`.
        To use audio pack, set `use_oggs` to `yes`.
    EOS
  end

  test do
    system bin"exult", "-v"
  end
end