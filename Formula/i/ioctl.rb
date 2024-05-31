class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https:docs.iotex.io"
  url "https:github.comiotexprojectiotex-corearchiverefstagsv1.14.1.tar.gz"
  sha256 "5e40e3dfba6d2bffb69a94b3611e0f393c94a3ca2f21032c2f31449fc3cc2e9c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40df4c8f57fb111035609a55b4b70e7770208852b6151f35e4d248af453539d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce895a4c59f88a7813623a0fd377ff7dc1350c9d11b6d64a517191f7da9651a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec4d08421df919d3b3c62e753c054dba85581b412fc04af467ce06952ef275ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "483f6efb385a018e1750670297f31b69f82e9fa8fff8ea7649c59036b8645205"
    sha256 cellar: :any_skip_relocation, ventura:        "7616c14922813dac91c669271d5b0b9477c45b1e3f2b2628242d98c0810998a8"
    sha256 cellar: :any_skip_relocation, monterey:       "edeb26d267ad8e20c2e7446096f715bd28d36d96e28b8312e9d0489eec368b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "776db9368946dc442e5819cc8e683fecf3c2caa0eeaae6d293c3a8eba34b5d7c"
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