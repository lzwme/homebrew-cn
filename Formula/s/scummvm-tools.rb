class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https:www.scummvm.org"
  url "https:downloads.scummvm.orgfrsscummvm-tools2.7.0scummvm-tools-2.7.0.tar.xz"
  sha256 "1d9f1faf8338a2fda64f0e6e14bc25a2dadced156cb28a9c60191b983d72db71"
  license "GPL-3.0-or-later"
  revision 2
  head "https:github.comscummvmscummvm-tools.git", branch: "master"

  livecheck do
    url "https:www.scummvm.orgdownloads"
    regex(href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa453544412c4f4031ffe6512016ace9647d5d979150a07172375f2243372ed1"
    sha256 cellar: :any,                 arm64_ventura:  "cbe02a0fcff8bfa723c4941e0c74049ad778361280bac5ed70f0d5691306e193"
    sha256 cellar: :any,                 arm64_monterey: "c5d03ba4d13a840ecf23191477dd4576d3fb0aceb44ffed1a02190b9ff6487f6"
    sha256 cellar: :any,                 sonoma:         "5841c6df9cb25eac0e918cd08bf5ecfae27c71df38f7018823357b3a20b61321"
    sha256 cellar: :any,                 ventura:        "f7f1732778a54b07e6fe30e6469bfad8aced68fd2b20b53401d88e0f4e596eb9"
    sha256 cellar: :any,                 monterey:       "86e1c2ec2958a881336a2f1197ebbdba96e369c064fc2ecce1eda87c1b4ee3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff2f01211d0b9fc025bf7cd69c299dd3fc62a2319980045db3b94d6086685e54"
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxwidgets"

  def install
    # configure will happily carry on even if it can't find wxwidgets,
    # so let's make sure the install method keeps working even when
    # the wxwidgets dependency version changes
    wxwidgets = deps.find { |dep| dep.name.match?(^wxwidgets(@\d+(\.\d+)?)?$) }
                    .to_formula

    # The configure script needs a little help finding our wx-config
    wxconfig = "wx-config-#{wxwidgets.version.major_minor}"
    inreplace "configure", ^_wxconfig=wx-config$, "_wxconfig=#{wxconfig}"

    system ".configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--enable-verbose-build"
    system "make", "install"
  end

  test do
    system bin"scummvm-tools-cli", "--list"
  end
end