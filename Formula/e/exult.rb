class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https:exult.sourceforge.io"
  url "https:github.comexultexultarchiverefstagsv1.10.tar.gz"
  sha256 "ec8f5bcc8d3a5a6ea454e67de484cf905e8c0c443257653416729a0fae8b0ec5"
  license "GPL-2.0-or-later"
  head "https:github.comexultexult.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia:  "3db510d288be2399096eebd522ba54569ca97fa603365cbed1a5efd0fb397c4f"
    sha256                               arm64_sonoma:   "f69afb3ad16b3fdeea5ea6d0c73a62394d7be9def9248a97f15d8c65e6bc32c2"
    sha256                               arm64_ventura:  "99251a0c8099a7218edeb452634b91a932bb31a39736a6382ebee51456b96474"
    sha256                               arm64_monterey: "12cbac14ecba98181ca8c577e81ed40d98a750aca40180f52e4532aeb4c87fd1"
    sha256                               sonoma:         "5170b7a35f26b2f9ddcd55fe28c3d8f44976efc04973dea7e5eb3d572ab8e257"
    sha256                               ventura:        "014df8593c8b8559f08181a8fde9a503eb5bc927e4dea12e4ccb5182dd7e5f5f"
    sha256                               monterey:       "0bee01b0b69655340e53d791d61c9a62cc0f5bea2d2e752357d8883e8165dc83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e04b77bd0b653ce3f5451850ff2ee2bcfeff84bcc98e41ff6999351098b2f406"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose"

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