class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://ghfast.top/https://github.com/cmus/cmus/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "44b96cd5f84b0d84c33097c48454232d5e6a19cd33b9b6503ba9c13b6686bfc7"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "1ae77a3ca4f13add2411b5db1af5b6169bd4c6c63c0223b7ec09efc71f172963"
    sha256 arm64_sonoma:  "a0e767af911891cc893e207a6cbf4039c57b5b8d1e06ef6c404e6af4932401e0"
    sha256 arm64_ventura: "b6f2e83dc571f755e4acbcd83c99e6f944a8f8913109ccc370a5f54ecb7c29c2"
    sha256 sonoma:        "be8ebf335b5a102dacb705a2308f4535fb6edd4d784c1dbb66b1bcc4c83ef581"
    sha256 ventura:       "6d0fc9fc52edea2ff0da6e4fc46d32de79cc5de6fe7a208910032da213f6dbac"
    sha256 arm64_linux:   "cf4d6856b39aca2481e86c9a04f0bc7570a0d77119a610ee814b64e605f24215"
    sha256 x86_64_linux:  "025d85801847e85f06e54da3b839ecd87af40822e4d926701e66db1ee8fc59ad"
  end

  depends_on "pkgconf" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libao" # See https://github.com/cmus/cmus/issues/1130
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "ncurses"
  depends_on "opusfile"

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    args = [
      "prefix=#{prefix}",
      "mandir=#{man}",
      "CONFIG_WAVPACK=n",
      "CONFIG_MPC=n",
      "CONFIG_AO=y",
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    plugins = shell_output("#{bin}/cmus --plugins")
    assert_match "ao", plugins
  end
end