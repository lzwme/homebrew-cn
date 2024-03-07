class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https:mudler.github.ioedgevpn"
  url "https:github.commudleredgevpnarchiverefstagsv0.24.6.tar.gz"
  sha256 "cc7fc9e15273e374cbf4ae72aa2d95748a0af36d92f3d16a0f26fc8c07ffd497"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e782d9f04ba55707b27b197991c7ebd6676d74822adda66fecfef96a6a6ce8c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e782d9f04ba55707b27b197991c7ebd6676d74822adda66fecfef96a6a6ce8c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e782d9f04ba55707b27b197991c7ebd6676d74822adda66fecfef96a6a6ce8c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ad1df33572d68e023f452b239b64bb88a654f4e0ab51c4f05da13675335f701"
    sha256 cellar: :any_skip_relocation, ventura:        "2ad1df33572d68e023f452b239b64bb88a654f4e0ab51c4f05da13675335f701"
    sha256 cellar: :any_skip_relocation, monterey:       "2ad1df33572d68e023f452b239b64bb88a654f4e0ab51c4f05da13675335f701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1f8101d28061ea67bf1b566c750abb3667b87df6e06738de97ae9358c149939"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    generate_token_output = pipe_output("#{bin}edgevpn -g")
    assert_match "otp:", generate_token_output
    assert_match "max_message_size: 20971520", generate_token_output
  end
end