class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://ghfast.top/https://github.com/mudler/edgevpn/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "1115a50182cdcfa3979a8b14f1f00526a244d340271e23eb6501e919178b99b7"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca56182bb0ec48e17211945b67a1d865c9b6a0b587057b78ac767099f1f01e99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca56182bb0ec48e17211945b67a1d865c9b6a0b587057b78ac767099f1f01e99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca56182bb0ec48e17211945b67a1d865c9b6a0b587057b78ac767099f1f01e99"
    sha256 cellar: :any_skip_relocation, sonoma:        "a39f9d1e127aa05e535e491f33b7f00fcc9456a612cf10f69c5565130f168d12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec806fa2521a88c9ac097c1d64ac0123dd619162c789babaae609061ebb16fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2630b93739bdda07a55af54751eb4c87ba25d3b2131b07860e94949ea5c4afea"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mudler/edgevpn/internal.Version=#{version}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    generate_token_output = pipe_output("#{bin}/edgevpn -g")
    assert_match "otp:", generate_token_output
    assert_match "max_message_size: 20971520", generate_token_output
  end
end