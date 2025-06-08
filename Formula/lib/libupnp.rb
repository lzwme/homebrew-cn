class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https:pupnp.sourceforge.io"
  url "https:github.compupnppupnpreleasesdownloadrelease-1.14.23libupnp-1.14.23.tar.bz2"
  sha256 "8c5946432124cf69928edf049b6ac16a861c35fa70a8bf7aa8fad65359945218"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^release[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49edc3f9bbdd39958fcc8dc048480f2c4ef3e4d1f3d525d4a9c86a02197a8236"
    sha256 cellar: :any,                 arm64_sonoma:  "b59e29b590345e846d69d46fec038ca7d850fd5c8bf2dcbb1cbca177dd57cf98"
    sha256 cellar: :any,                 arm64_ventura: "c75b7403a6407f00a03a1a1dedf0f6b27027be35edfb4a09268c5e130b2a7528"
    sha256 cellar: :any,                 sonoma:        "3db50b401b92c512e087b92f5a665450db68811eb7c5e2e70e124b9af17d93ba"
    sha256 cellar: :any,                 ventura:       "6f55d3a00dc8e80993fc02439d6df8a3f6aa1f21881197a607e2cad85564f09f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc02440ee39ebfb96113830680be06c1d9eaf197946fb28261888e647ef2ae13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6949c056fb3e265768758d2ffae5723e68ff9e3a9ef9c2d5ac3c9beac31af3ed"
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