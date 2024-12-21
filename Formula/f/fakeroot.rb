class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https:tracker.debian.orgpkgfakeroot"
  url "https:deb.debian.orgdebianpoolmainffakerootfakeroot_1.36.1.orig.tar.gz"
  sha256 "ed828389ebe8fa7923acc9a03c72aac47a1db254c97aa1bfaffc2618fb532fdf"
  license "GPL-3.0-or-later"

  livecheck do
    url "https:deb.debian.orgdebianpoolmainffakeroot"
    regex(href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d45786ae8a5517b67abe2bbbccd809410e3a6a8c3d33651847f4ff0494e9254e"
    sha256 cellar: :any,                 arm64_sonoma:  "01819bdea2919163a04647e4ff347425bf8f5dfccd32cf20267dae2b7076ec03"
    sha256 cellar: :any,                 arm64_ventura: "6964b20bb3e23f9df3b7cba50cfd1bb6da59b4ee59f7320e5c875aa6958bd2c3"
    sha256 cellar: :any,                 sonoma:        "a88ab35aba724a5010c9b11880750e2797a38010b9892e9521d103c23cca70ea"
    sha256 cellar: :any,                 ventura:       "2d666b8df97773192a311b40fdfb5f4d4ceeb70e3c9e530719b9af68c9b6731f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f644b71e12b5525bb7c6d680c990dd43d01454a09509912f829542d7c5f4fab"
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