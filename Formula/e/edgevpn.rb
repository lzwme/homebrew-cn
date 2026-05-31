class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://ghfast.top/https://github.com/mudler/edgevpn/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "916d815e0a423c0538aa9e4452670d3c27c6ed6ea7867cebb698914e073c56ed"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08b265a447cbda428df05dc9d207e6304b053e899f3bf41a51ac61e6d92b0ac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08b265a447cbda428df05dc9d207e6304b053e899f3bf41a51ac61e6d92b0ac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08b265a447cbda428df05dc9d207e6304b053e899f3bf41a51ac61e6d92b0ac7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d55de69eba842edf4d46c595833f62aab52352a7eef3a255d76496831b04c18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06b548894dc6b2a61d5cb539e663934efd8f0540889a705a444f6fad3b77e6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e1f3aff424f4276a7f995e79edf6bc7ebb1125b6ee6c268422ed8c1b280ae8d"
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