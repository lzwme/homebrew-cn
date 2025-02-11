class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https:mudler.github.ioedgevpn"
  url "https:github.commudleredgevpnarchiverefstagsv0.30.0.tar.gz"
  sha256 "f152cc7aceb5252a4cb395a2e4f06968900c45d1ecd34269d3d69eb0f311ed00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c5d0a36fe3d4726eeb6c6cf24b64f16cc89d9c36182351c7e5ac8cb91304dfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c5d0a36fe3d4726eeb6c6cf24b64f16cc89d9c36182351c7e5ac8cb91304dfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c5d0a36fe3d4726eeb6c6cf24b64f16cc89d9c36182351c7e5ac8cb91304dfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "721785b9b67741766e76ad44d2a674baa22149534d0bd8c30ff78a640062b291"
    sha256 cellar: :any_skip_relocation, ventura:       "721785b9b67741766e76ad44d2a674baa22149534d0bd8c30ff78a640062b291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f82e98cd7c86ef8622b27d692b5b78ae55974846483295588c7fcab8a8ccae68"
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