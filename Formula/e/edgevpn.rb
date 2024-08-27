class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https:mudler.github.ioedgevpn"
  url "https:github.commudleredgevpnarchiverefstagsv0.27.4.tar.gz"
  sha256 "ad60e61e9346a61e80ac251845dc2a4265b53d547a218ab2b73867d924bb92f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b38efd6bc0cd41de0ce8598a33f3ec4ffb0dc92324c78cd8feb1a817e98c5508"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b38efd6bc0cd41de0ce8598a33f3ec4ffb0dc92324c78cd8feb1a817e98c5508"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b38efd6bc0cd41de0ce8598a33f3ec4ffb0dc92324c78cd8feb1a817e98c5508"
    sha256 cellar: :any_skip_relocation, sonoma:         "b74f443680cf6a35b58b32a2deecfb97dc467bd38d7040cdfcea91de8b282051"
    sha256 cellar: :any_skip_relocation, ventura:        "b74f443680cf6a35b58b32a2deecfb97dc467bd38d7040cdfcea91de8b282051"
    sha256 cellar: :any_skip_relocation, monterey:       "b74f443680cf6a35b58b32a2deecfb97dc467bd38d7040cdfcea91de8b282051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f68b8b9f6648f2fa2ea5d182b1b6de26651bf04ae1acb67daf8d1cde81bee46"
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