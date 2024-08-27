class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https:docs.iotex.io"
  url "https:github.comiotexprojectiotex-corearchiverefstagsv2.0.3.tar.gz"
  sha256 "401f0fc72949b8d96f3e18bc1c8379397c4690f57006ba94b61b7d5c17704cf6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1373a43d3c4c93d90bc95bd4b303bd901637cb8c0e13e6acfd129c2f8e374763"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "036ad2e6230ff859c8b7019f6c70e040ffed75a18eb1d0b9877ea076cda01a47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19617e515c384b147f1318bf16ce97a18569c1e27d65928c6d5d7ca33000990d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c84b08eeccc792d0f7194920e395badf08926fdd01d3c7bfce43fcd59550b29b"
    sha256 cellar: :any_skip_relocation, ventura:        "a21ce38df8336cdd33e9de76282067d7c082d19834b64b56ef233815855bcc07"
    sha256 cellar: :any_skip_relocation, monterey:       "1adba8a1a26dcb3a4d3afee2217153f058d26f668dd4ab4cc241973017b1fd82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9cd7011c0a1fbbb644bc455aea178fc418ad2c5fae777035aa176db09a5631"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "binioctl"
  end

  test do
    output = shell_output "#{bin}ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end