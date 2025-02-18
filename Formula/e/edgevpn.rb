class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https:mudler.github.ioedgevpn"
  url "https:github.commudleredgevpnarchiverefstagsv0.30.1.tar.gz"
  sha256 "576d0e64c4ac665787e63e97634c4379f2ad646e9b1ab74e4c62124380d5ebb7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d4110c762e1783ef3a98bbca249fe45e7e4c61d9394014f66cb118f66a01175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d4110c762e1783ef3a98bbca249fe45e7e4c61d9394014f66cb118f66a01175"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d4110c762e1783ef3a98bbca249fe45e7e4c61d9394014f66cb118f66a01175"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bc199ec38a7027cc1115f93f788693597bc0227c625ac98f4935f69348b8a0b"
    sha256 cellar: :any_skip_relocation, ventura:       "0bc199ec38a7027cc1115f93f788693597bc0227c625ac98f4935f69348b8a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c552dea00fe83f63838068767124e6cee18178628b1800b4015ae59284157c2a"
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