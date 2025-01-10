class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https:mudler.github.ioedgevpn"
  url "https:github.commudleredgevpnarchiverefstagsv0.29.0.tar.gz"
  sha256 "c65a3dc3bc202020c30ce7030132a587eea761994ce4f94c1460dd026761cc92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5992dc6f141dd9a3d9497b4ddee67a7738e613b986ccf4db8dc60900029ada1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5992dc6f141dd9a3d9497b4ddee67a7738e613b986ccf4db8dc60900029ada1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5992dc6f141dd9a3d9497b4ddee67a7738e613b986ccf4db8dc60900029ada1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d1a63460ae803d286ea49e4d94769b53b649bb1d538927071a53fbc88bf34ba"
    sha256 cellar: :any_skip_relocation, ventura:       "6d1a63460ae803d286ea49e4d94769b53b649bb1d538927071a53fbc88bf34ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "822d4823bb14142282f4dbc85a5df3ae44057b88b1d858e1b2ba70756882d5db"
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