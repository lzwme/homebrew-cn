class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https:tracker.debian.orgpkgfakeroot"
  url "https:deb.debian.orgdebianpoolmainffakerootfakeroot_1.33.orig.tar.gz"
  sha256 "e157d8e5c64d3a755707791e9be93296c6d249d5c4478bf941b675d49c47757d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https:deb.debian.orgdebianpoolmainffakeroot"
    regex(href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "25776c62dd7275c3e868581de91c49bbd8f3559dffef8f4497c9422257dd57d8"
    sha256 cellar: :any,                 arm64_ventura:  "ed9171133e3d7bfe7be1d53760cc93f91cf999fabdb942f5234656a91ab9287d"
    sha256 cellar: :any,                 arm64_monterey: "74e7a8e5472d22eb4d553dfc671656a4aaa3bdce96af6672448b04cfcc16acef"
    sha256 cellar: :any,                 sonoma:         "ba03c6255bf70fc26f35bfcd74e339cd94c3297a8264d74c46902c5471184e9f"
    sha256 cellar: :any,                 ventura:        "627f864887cbcb32245f4c89d025e6f96f1b0a88010641b0cf320434548a8215"
    sha256 cellar: :any,                 monterey:       "88d34d6ba142873cc3bb01bc81977b85237475de022b338a4e7e7a44f5004748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b591f56ac7e87e79e344354dfe593e86b07b0247dc4159abaf8a9a28794257d"
  end

  # Needed to apply patches below. Remove when no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libcap" => :build
  end

  # https:salsa.debian.orgclintfakeroot-merge_requests17
  patch :p0 do
    # The MR has a typo, so we use MacPorts' version.
    url "https:raw.githubusercontent.commacportsmacports-ports0ffd857cab7b021f9dbf2cbc876d8025b6aefeffsysutilsfakerootfilespatch-message.h.diff"
    sha256 "6540eef1c31ffb4ed636c1f4750ee668d2effdfe308d975d835aa518731c72dc"
  end

  def install
    system ".bootstrap" # remove when patches are no longer needed

    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system ".configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fakeroot -v")
  end
end