class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://ghproxy.com/https://github.com/ipinfo/cli/archive/refs/tags/ipinfo-3.1.1.tar.gz"
  sha256 "02cebd2741780bc806ca5565e260b326bbd20ff58ccc74cea2ade2d9866fc7fa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccc00f0f31ac84d9001b74e0d6b4b8fcd220b2f2bd55b62420c963a796fc52ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a7e5f9dd49af94f818ca06b134178264305b0ced44af0f9479125037291dd16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "292f32b1939171512069de7b1bed207ff655f3c9d2f9bcfcc5013b6df745a5cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "23625e0e1ffc90b2675e0637e581ac0ab9f9523ad6469b88cbc1e7e45445cb54"
    sha256 cellar: :any_skip_relocation, ventura:        "b813315e23f97ee7ff17617bea66495e5e53deb949fa6b2b3880bb81009ce3c0"
    sha256 cellar: :any_skip_relocation, monterey:       "c1a98f203e802cd1eaa66cf37f621e7c8ab514db53638eadc3c3f04b952d4b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a0fd945bf8832d42c7c90c4920b7201a47f7b7e427c6a63467220cdab6a2fd3"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end