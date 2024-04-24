class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https:mudler.github.ioedgevpn"
  url "https:github.commudleredgevpnarchiverefstagsv0.25.2.tar.gz"
  sha256 "cd9168aa02ed31bfbc932098448b66293a2b02d652d7872238a98aae0b31a18c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25c04c8908aedcd15c87d36a8930898df8f8e6d2afb5c38891e0f860b4421a52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25c04c8908aedcd15c87d36a8930898df8f8e6d2afb5c38891e0f860b4421a52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c04c8908aedcd15c87d36a8930898df8f8e6d2afb5c38891e0f860b4421a52"
    sha256 cellar: :any_skip_relocation, sonoma:         "a77c50dcecef83d06fe5c08753f541785df81a29902c89ae08e0a43b2c9d61e9"
    sha256 cellar: :any_skip_relocation, ventura:        "a77c50dcecef83d06fe5c08753f541785df81a29902c89ae08e0a43b2c9d61e9"
    sha256 cellar: :any_skip_relocation, monterey:       "a77c50dcecef83d06fe5c08753f541785df81a29902c89ae08e0a43b2c9d61e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd0aeb50ca2652852f54785ef9831aa90a485335ae4d603add08a0b638f0191"
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