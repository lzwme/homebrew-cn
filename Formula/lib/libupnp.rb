class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-1.14.28/libupnp-1.14.28.tar.bz2"
  sha256 "5928520ab205a38c383b9e2d4d89db4642f127b5ce54e6af4f038bdfb09befa7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e8b85529ff730e2f0fcbbc90b4de7a338d2d6bf08627f71d323d6d2df4945eb"
    sha256 cellar: :any,                 arm64_sequoia: "d26c4d6b8d1de61dbf4a9dd427d4c6ebf1a95a5aa893f5ab628190edbd6f799b"
    sha256 cellar: :any,                 arm64_sonoma:  "e2aa516d4349553defa4d53900ca4909bd814385613f586ce2ccf5757aae0302"
    sha256 cellar: :any,                 sonoma:        "c5d3e28a65c19a0497d40bb5251f40febc1cc30d26b0ef0ca28ef22d390f4de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3d040054b4000613453a7364d959a734e40e8e06e3cf80d370829e710722564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d19c6f947f26b2235df7f822e2bf0f5080f70157134bbfbde373024acf1e6c33"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end