class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://git.ffmpeg.org/rtmpdump.git",
      tag:      "v2.6",
      revision: "138fdb258d9fc26f1843fd1b891180416c9dc575"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://git.ffmpeg.org/rtmpdump.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6da0c98fc9ec24bc43ef856f523ac07746b7612d9ff9e95089957c79578f6550"
    sha256 cellar: :any,                 arm64_sequoia: "8eafa2bb31efb613a6dc317042ef72b72f6732cc8188bfbee84ad63732e06266"
    sha256 cellar: :any,                 arm64_sonoma:  "01c87c00b31444f8d52e257a4023ffa42747f57a9e03228686bb52e3578ce42f"
    sha256 cellar: :any,                 sonoma:        "526ac3a9d62403dbbb2cd2917c9e6c89d64a718897f26e11e23f762aaff0e0fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50bb89c9c4b6684266523fca57729bf10ffb1855d81846b9a972fa67d333ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d157b751c5de5997aeeb24acb57d4d296fb715a50ae42f0a4e1f793fbde641a8"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with "flvstreamer", because: "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

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
    system bin/"rtmpdump", "-h"
  end
end