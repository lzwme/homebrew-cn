class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https:rtmpdump.mplayerhq.hu"
  url "https:deb.debian.orgdebianpoolmainrrtmpdumprtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  mirror "http:deb.debian.orgdebianpoolmainrrtmpdumprtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4-20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 3
  head "https:git.ffmpeg.orgrtmpdump.git", branch: "master"

  livecheck do
    url "https:cdn-aws.deb.debian.orgdebianpoolmainrrtmpdump"
    regex(href=.*?rtmpdump[._-]v?(\d+(?:[.+]\d+)+)[^"' >]*?\.orig\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fc5748b95d47c39bb4d633090cc0a7b5fe90bda5ef163fa5b8809272c9bf4618"
    sha256 cellar: :any,                 arm64_ventura:  "1dec5a57d0173f54cb1f38efb6bfbd0bc416bdb298289ebaac1dce3a41bdd6fb"
    sha256 cellar: :any,                 arm64_monterey: "5151b4682fa17d931e6383dd06b584d822df647fd454b22ddf498525606cff39"
    sha256 cellar: :any,                 arm64_big_sur:  "b548e2d6b53bc0d03bdc73fb01a175c8ef2338f80a3ca0c1963af625f0baa523"
    sha256 cellar: :any,                 sonoma:         "5d019561203c8b1c1c1e69c48b3987d531c55fa806bd83f0a462b6b7da732f48"
    sha256 cellar: :any,                 ventura:        "b27c24194ded10a47b93a379efae8ead4b04a6d3e8e34bc3a70942380b1ed68b"
    sha256 cellar: :any,                 monterey:       "b942d0dee2c95a00b3fd080c50d1f0d715448ae3147bbb18cf5adb758cb63798"
    sha256 cellar: :any,                 big_sur:        "794073edbf7402af7750b21fbcb44c5df038d6d3606450bd6a453dc92b6b3b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab7f054fd0b01975be1893437235c61e2761ed9fb54e7880a854ca37809d57e"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with "flvstreamer", because: "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  # Patch for OpenSSL 1.1 compatibility
  # Taken from https:github.comJudgeZarbiRTMPDump-OpenSSL-1.1
  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patches85fa66a9rtmpdumpopenssl-1.1.diff"
    sha256 "3c9167e642faa9a72c1789e7e0fb1ff66adb11d721da4bd92e648cb206c4a2bd"
  end

  def install
    ENV.deparallelize

    os = if OS.mac?
      "darwin"
    else
      "posix"
    end

    system "make", "CC=#{ENV.cc}",
                   "XCFLAGS=#{ENV.cflags}",
                   "XLDFLAGS=#{ENV.ldflags}",
                   "MANDIR=#{man}",
                   "SYS=#{os}",
                   "prefix=#{prefix}",
                   "sbindir=#{bin}",
                   "install"
  end

  test do
    system "#{bin}rtmpdump", "-h"
  end
end