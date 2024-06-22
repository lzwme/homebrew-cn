class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https:mudler.github.ioedgevpn"
  url "https:github.commudleredgevpnarchiverefstagsv0.26.1.tar.gz"
  sha256 "cbd0fa9a1dd496d5a941470ad22619d4338b20965aff8f4c1625562386d6b564"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba951cb8a91a57e30e1423a220f56555a7580faf732c3eeaa8a5da3cecf17afc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba951cb8a91a57e30e1423a220f56555a7580faf732c3eeaa8a5da3cecf17afc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba951cb8a91a57e30e1423a220f56555a7580faf732c3eeaa8a5da3cecf17afc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d84c899d11ff6c5752269a02b988f9fe4283c87420fc13d95770fe0f7e3c918"
    sha256 cellar: :any_skip_relocation, ventura:        "2d84c899d11ff6c5752269a02b988f9fe4283c87420fc13d95770fe0f7e3c918"
    sha256 cellar: :any_skip_relocation, monterey:       "2d84c899d11ff6c5752269a02b988f9fe4283c87420fc13d95770fe0f7e3c918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "834962e29d9b94a1b11997bf9a2ab4ec85ebd9adf6ffa3a489fa0004b7f312d4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commudleredgevpninternal.Version=#{version}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    generate_token_output = pipe_output("#{bin}edgevpn -g")
    assert_match "otp:", generate_token_output
    assert_match "max_message_size: 20971520", generate_token_output
  end
end