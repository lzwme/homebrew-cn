class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https:mudler.github.ioedgevpn"
  url "https:github.commudleredgevpnarchiverefstagsv0.28.4.tar.gz"
  sha256 "07921598a18029fb2141915d06447454cbc33474269685a30e61465e94de77e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05f431ac5cfe371887c537898d0b5e09eb512bbb2174262e057bf92a553113ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05f431ac5cfe371887c537898d0b5e09eb512bbb2174262e057bf92a553113ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05f431ac5cfe371887c537898d0b5e09eb512bbb2174262e057bf92a553113ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ccdd4c3d9638676447408b6e940f4d09f1c41da9140ddbfeb217cb4d979676f"
    sha256 cellar: :any_skip_relocation, ventura:       "2ccdd4c3d9638676447408b6e940f4d09f1c41da9140ddbfeb217cb4d979676f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c75542018e0836a736f98ddc19487ba2700026da0bfba83b362a875f5505994a"
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