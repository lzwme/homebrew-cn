class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://ghproxy.com/https://github.com/iotexproject/iotex-core/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "f4cc8a208d3263bf370f6ff398f77a342ca1ab3fc4a512c0ea9be198ec3fe1d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6c94037f976d961bd958f3e26eb3960f2fc33ce83091cf7ce03c6655b3397e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "603d8872f31df45a1a154e3954abba3366e020c05f1694baaa74c10b0cd81fff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4871e381ff9e48fc8c1209c79eafc8feabdee11ff36e8ae41617014e8daabed6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5dbd1f9af6bc768b975333bf7e18fa1d9ae1fc211174507224bd2ea422bea2eb"
    sha256 cellar: :any_skip_relocation, ventura:        "fa917ffc90f2067ff2be7f005cddd17125a60bd31b186c646529e256df6d712c"
    sha256 cellar: :any_skip_relocation, monterey:       "8ba413c7e5f8faa382fc01114a66f7fa3e9aae6c2f218e48d9d853581b2182d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f763f9436f2a077ad15fe1f894d9dd8bdfe314efa19b129ca1d3eec79eb6f75"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end