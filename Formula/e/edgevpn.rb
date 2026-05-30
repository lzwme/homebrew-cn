class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://ghfast.top/https://github.com/mudler/edgevpn/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "3dbfa1f95e020b8b26dbcc662e34340c2bc54cf45143d7429f1aad598f811821"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3c0c607e2a92cf7a8d50ceca27d4acf1c6828bf81a08fd6d3a98b5831718829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c0c607e2a92cf7a8d50ceca27d4acf1c6828bf81a08fd6d3a98b5831718829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3c0c607e2a92cf7a8d50ceca27d4acf1c6828bf81a08fd6d3a98b5831718829"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeb431cce764210f7090427df3b0fa29cb35eaa7f5108a32aeb6e207c415dea0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b3a621cb4a971be54fc8f8af7cfead690aee952025a7cbe22be28d03f78ae13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e27978b9e9ea24bbf135c5fbfff7b7e812ac3a7c914d6b74530c30c04322d9ba"
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