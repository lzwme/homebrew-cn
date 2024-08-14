class Tcpsplit < Formula
  desc "Break a packet trace into some number of sub-traces"
  homepage "https://web.archive.org/web/20230609122227/https://www.icir.org/mallman/software/tcpsplit/"
  url "https://web.archive.org/web/20230609122227/https://www.icir.org/mallman/software/tcpsplit/tcpsplit-0.2.tar.gz"
  sha256 "885a6609d04eb35f31f1c6f06a0b9afd88776d85dec0caa33a86cef3f3c09d1d"
  # The license is similar to X11 but with a different phrasing to the no advertising clause
  license :cannot_represent

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59062e48ff67f9fc5a6b0f8d0cc397c888b1914c2881ac663d6ce8f9a074a34d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3d3cd3c37dce379aa221133969b74a0b2bd61a6d7605172b952b26e3398a0cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bf4362d064b7f982e0fb8cb2e79010c80c19f555b79f18dd0e4f3a9dbfda8a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f40f957faef51ed496030a97cda8ca0eb0716826969872185080bb8e94780f36"
    sha256 cellar: :any_skip_relocation, sonoma:         "4223a133c41217be90d0880fd1480e68e2b540fe4ab448144a14afa6d4139811"
    sha256 cellar: :any_skip_relocation, ventura:        "1931a69c46a6669e5a5a9716b260413bcbf24af89bb567ccde1bb17e1827f55a"
    sha256 cellar: :any_skip_relocation, monterey:       "51e4f267ddd4cd76011a85b0e094d78d4df67b4a3d16d6dd918834a929cba203"
    sha256 cellar: :any_skip_relocation, big_sur:        "49781c99d1496c5c0c8ec3e56e2edc604f5e8643f36e93b0ff8b974d448363d1"
    sha256 cellar: :any_skip_relocation, catalina:       "ab3131cd8829f943cc4142dc616adfa696ff9d0af5dc21f94408d114f59434cd"
    sha256 cellar: :any_skip_relocation, mojave:         "b3a7f083a50a33edf1799fc16b6d52db71eee85bd69bad9d1d3d42e6de5cfa6f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0b603f1737a000ec2452bd3ac48df7c4e04d6cfb15fc48dabca96bd23137f40a"
    sha256 cellar: :any_skip_relocation, sierra:         "2e9d12ee609d30075f141527c3804ce78a8c312e5b72ce6eb655ed08521faf45"
    sha256 cellar: :any_skip_relocation, el_capitan:     "5014edcbc87913b2103c9347dd4b132ca1b4c3b1a007c853eda75213481e7d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f90bcbd78ee73c48c113f3f2b974c5aa6b2e17cecb6fa531be3a62a40fa0fb9f"
  end

  # Upstream has an incomplete certificate chain,
  # so fetching and livechecking no longer work.
  # Last release on 2013-02-27
  deprecate! date: "2023-12-05", because: :unmaintained

  uses_from_macos "libpcap"

  def install
    system "make"
    bin.install "tcpsplit"
  end

  test do
    system bin/"tcpsplit", "--version"
  end
end