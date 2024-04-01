class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https:www.scummvm.org"
  url "https:downloads.scummvm.orgfrsscummvm2.8.1scummvm-2.8.1.tar.xz"
  sha256 "7e97f4a13d22d570b70c9b357c941999be71deb9186039c87d82bbd9c20727b7"
  license "GPL-3.0-or-later"
  head "https:github.comscummvmscummvm.git", branch: "master"

  livecheck do
    url "https:www.scummvm.orgdownloads"
    regex(href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "c44f4a4e1b16c1790c568771685a76f05605893115ca3a63d8ce2557980c465c"
    sha256 arm64_ventura:  "7f950fa117d3bab3e1ca004553bcdd92e90745c61e1649d335080d943edb0908"
    sha256 arm64_monterey: "ea8532ff998496baac8bcc3dd7ce5477ec55334aa8135cc3ff8b351dda9a6612"
    sha256 sonoma:         "bcbc350baf55eaade92ed2234489817e789968af89ee9a2d590c8a5ed5c7a022"
    sha256 ventura:        "43f3fb2fbe4a43f740d64f7537f5c9eff7abd8ba369f7225faaeec87076dfcdc"
    sha256 monterey:       "032a608ef20f46be4d3ceeebdf0fd7a6448e25c625e1b390f07ed57753912dc1"
    sha256 x86_64_linux:   "f3976b07dfc1b1d133f975f9a9b9da7de5ea88871cc9ce88307c83d6af3071d3"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  def install
    system ".configure", "--prefix=#{prefix}",
                          "--enable-release",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}"
    system "make"
    system "make", "install"
    (share"pixmaps").rmtree
    (share"icons").rmtree
  end

  test do
    # Use dummy driver to avoid issues with headless CI
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    system bin"scummvm", "-v"
  end
end