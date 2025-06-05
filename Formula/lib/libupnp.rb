class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https:pupnp.sourceforge.io"
  url "https:github.compupnppupnpreleasesdownloadrelease-1.14.22libupnp-1.14.22.tar.bz2"
  sha256 "eec53b0f822d8298c41d02e89c4df6d099935dbd94ca3260bf6dab9a9d56d64d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^release[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dc4351ba5e22d71c2eecce4ffbdbd279888c7698e9484c5723b60993161b44ae"
    sha256 cellar: :any,                 arm64_sonoma:  "f4dc245a698fd500fe4cd4f8eb20ef7751140fec07ece5e7b7eb654bd6454bb3"
    sha256 cellar: :any,                 arm64_ventura: "efa156bde198ffbe5f07123e168b629c27ed767371b06723cb97d0e36fc99081"
    sha256 cellar: :any,                 sonoma:        "17e810bf420c5693bd167f28785fbfe2db177766bd99c5d7b7ebfa416e87111b"
    sha256 cellar: :any,                 ventura:       "946bacfd60f6e71ee07671dee79e7823abe217a817b77adbe84018cffe9282a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "911ee4d7bad2458c9bed9e72d59c92cb652943524ac5b3fe748972516e7c656a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98deb92ca6f246a1b3890d79329080400d61178f0f866e90300ae0da496d20dd"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system ".configure", *args
    system "make", "install"
  end
end