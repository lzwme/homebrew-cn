class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https:tracker.debian.orgpkgfakeroot"
  url "https:deb.debian.orgdebianpoolmainffakerootfakeroot_1.37.1.orig.tar.gz"
  sha256 "1af13a9745d5c2b5ef691623c9a435417fb5549d549f17633723463c34095162"
  license "GPL-3.0-or-later"

  livecheck do
    url "https:deb.debian.orgdebianpoolmainffakeroot"
    regex(href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3730aac6ce68eb5d1e76767ca61b983c675352bf841b55b439342aa7cdfc270a"
    sha256 cellar: :any,                 arm64_sonoma:  "99d7666805714b6979eec6ac112b238cc8cc73aebfc46d21889d24798701b4d0"
    sha256 cellar: :any,                 arm64_ventura: "c552912b25cee2d88ada5224e074a5b013e2eaa2964f4cbf80542e3c3e5efe8a"
    sha256 cellar: :any,                 sonoma:        "3d0820a8097519e4c4b0e084ed0c02570a6486f487098388432491255f4d7eb0"
    sha256 cellar: :any,                 ventura:       "c8859c1d4fe56237340985686175088727ec82097e48b11ff2582f106da67e69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51018e8f97c0d71f27670da8a3deffaee6c696bee7f6baa203f880ddc73a87c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "599a226ad7bf5a077bc57f95c44e7d60d5a3fc45c6df3450a1c64bb6dc6d2964"
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