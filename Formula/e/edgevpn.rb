class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https:mudler.github.ioedgevpn"
  url "https:github.commudleredgevpnarchiverefstagsv0.25.3.tar.gz"
  sha256 "8a671bea7f085e8150e2f617f78ce6d583ea21f3a50cbc328e29d0d97dddfb6f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "961e9d7e01b59186ca8ebf9df662b121405f3412d5a783c987fe9a0aa977d583"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "961e9d7e01b59186ca8ebf9df662b121405f3412d5a783c987fe9a0aa977d583"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "961e9d7e01b59186ca8ebf9df662b121405f3412d5a783c987fe9a0aa977d583"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ef403c59fb8e7f69dcc97e57acc101b680ed5a6f79c1537150fdf18b3ddabdc"
    sha256 cellar: :any_skip_relocation, ventura:        "2ef403c59fb8e7f69dcc97e57acc101b680ed5a6f79c1537150fdf18b3ddabdc"
    sha256 cellar: :any_skip_relocation, monterey:       "2ef403c59fb8e7f69dcc97e57acc101b680ed5a6f79c1537150fdf18b3ddabdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98656012969c0db2b2d30108ce42aefec92484d363d3d680952ab65bf109a53"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
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