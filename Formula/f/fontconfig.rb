class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/2.18.0/fontconfig-2.18.0.tar.gz"
  sha256 "5c94af4828988af6b1a8484ddba13b521162687f9e5129bd8f267b8f4cfbf619"
  license all_of: [
    "HPND-sell-variant",
    "Unicode-3.0",        # fc-case/CaseFolding.txt
    "MIT-Modern-Variant", # src/fcatomic.h, src/fcmutex.h
    "MIT",                # src/fcfoundry.h
    :public_domain,       # src/fcmd5.h, src/ftglue.[ch]
  ]
  compatibility_version 1
  head "https://gitlab.freedesktop.org/fontconfig/fontconfig.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+\.\d+\.(?:\d|[0-8]\d+))/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9cb58e17e651f385706a175dc39e61e4bebe21e0494ee76860a9220ebdc34b0d"
    sha256 arm64_sequoia: "a71afe82d6c330944a018d1ef9c2faf3a828ec6331ad1dfbeac5cae2f8a0196d"
    sha256 arm64_sonoma:  "3c19f5b2119854bcbc6a47aec3eb933379dedf7ca20e198a33e3c567883d4e6c"
    sha256 sonoma:        "44e89d4af7cb34b7638e1d6450934afc2bac0755499aaa7addfd193c98311dbd"
    sha256 arm64_linux:   "c1f1ab529da55d66b7db850d1dcb17d49c44f6820a26280685b8d62290b45ec9"
    sha256 x86_64_linux:  "919c98bd2c6b085c6a182b47aae7d4deaddb3e39d2dbe1d1344cf0713f1ad744"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
  end

  def install
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    font_dirs << Dir["/System/Library/Assets{,V2}/com_apple_MobileAsset_Font*"].max if OS.mac?

    args = %W[
      --default-library=both
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      -Ddoc=disabled
      -Dtests=disabled
      -Dtools=enabled
      -Dcache-build=disabled
      -Ddefault-fonts-dirs=#{font_dirs}
      -Dadditional-fonts-dirs=no
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    ohai "Regenerating font cache, this may take a while"
    system bin/"fc-cache", "--force", "--really-force", "--verbose"
  end

  test do
    system bin/"fc-list"
  end
end