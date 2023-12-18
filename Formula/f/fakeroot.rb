class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https:tracker.debian.orgpkgfakeroot"
  url "https:deb.debian.orgdebianpoolmainffakerootfakeroot_1.32.2.orig.tar.gz"
  sha256 "f0f72b504f288eea5b043cd5fe37585bc163f5acaacd386e1976b1055686116d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https:deb.debian.orgdebianpoolmainffakeroot"
    regex(href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da7eda39219051fe1b2bf15b7e31781907ece61f35b7aeae8dc6df87753c5cce"
    sha256 cellar: :any,                 arm64_ventura:  "b3d122820d185f954d6483d7bbc4ab4396b7284f7721391feec0ec563cbaf146"
    sha256 cellar: :any,                 arm64_monterey: "6f166ccc59a0072784a0a00385bed3510f84c31f43c5d7c9c0480a351469a33f"
    sha256 cellar: :any,                 sonoma:         "ff7e6a5c458601a6fdf966f557fa0f78b9753ea7c158fc6ce50af5421e1e9052"
    sha256 cellar: :any,                 ventura:        "2c5aaf5e16dac86591436f2723bf0742d8d882d0a8d35bd98206dfabc77818f3"
    sha256 cellar: :any,                 monterey:       "1b1daa9b8595b81ca91bd10654d592abf6dbd8689123e1ade9ea6f40b38c298a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1666402c6faa2b4af59446398a4fd43f5d524f21e6ba80c984c27dc69fd1f780"
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