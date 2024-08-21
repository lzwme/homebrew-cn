class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https:mudler.github.ioedgevpn"
  url "https:github.commudleredgevpnarchiverefstagsv0.27.2.tar.gz"
  sha256 "20f01b148f0b8176ec15f7e7ed6840d11698291be86dcc13ed3ba9d92605e4cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0735f6e5aaa5a979ea64578d0cb49aa514b93bb644ffc14e8078878ab508b435"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0735f6e5aaa5a979ea64578d0cb49aa514b93bb644ffc14e8078878ab508b435"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0735f6e5aaa5a979ea64578d0cb49aa514b93bb644ffc14e8078878ab508b435"
    sha256 cellar: :any_skip_relocation, sonoma:         "e56da93396e4d41144d5da4ba1fbdd3a2da941f5419eec5d3b4768b975216e0a"
    sha256 cellar: :any_skip_relocation, ventura:        "e56da93396e4d41144d5da4ba1fbdd3a2da941f5419eec5d3b4768b975216e0a"
    sha256 cellar: :any_skip_relocation, monterey:       "e56da93396e4d41144d5da4ba1fbdd3a2da941f5419eec5d3b4768b975216e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4339ef40e830ba6f85ae947d52fe869afad9fdb15abc594427cf538d9a26bed"
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