class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://ghfast.top/https://github.com/mudler/edgevpn/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "954c4496f944a7856d62ed3a513d08d8a24936de980ad7d9e60fac47b53aa8da"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11be39a4e3c030035667e2be8ccca2fbf050f1189baabcc23e237f5d199907e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11be39a4e3c030035667e2be8ccca2fbf050f1189baabcc23e237f5d199907e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11be39a4e3c030035667e2be8ccca2fbf050f1189baabcc23e237f5d199907e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee426e010211a2f60e888c1d55576da41e570403637a62244482f65796a13373"
    sha256 cellar: :any_skip_relocation, ventura:       "ee426e010211a2f60e888c1d55576da41e570403637a62244482f65796a13373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1376c05a07ebf5a286266d2d6e0616bcf384b197ab61774a7ac09e10a6ba2978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30cc58b27ecd610b5e2b6291ae3e7e6b210e0d5d1c3dd8898d8877e9f4be1e97"
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