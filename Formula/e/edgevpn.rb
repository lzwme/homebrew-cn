class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https:mudler.github.ioedgevpn"
  url "https:github.commudleredgevpnarchiverefstagsv0.27.3.tar.gz"
  sha256 "7dc2617cc8a7f157ba7b17d50f340207d8798f85edb722bed24c0ff112bac0de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e1b2efebe5487d18ef95da1111abef339f6eb7bb83a20991649f6154e19402d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e1b2efebe5487d18ef95da1111abef339f6eb7bb83a20991649f6154e19402d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e1b2efebe5487d18ef95da1111abef339f6eb7bb83a20991649f6154e19402d"
    sha256 cellar: :any_skip_relocation, sonoma:         "54770d5bb213b324f1454712358ef12a096e5b47cd92a05101ab9d09764ea858"
    sha256 cellar: :any_skip_relocation, ventura:        "54770d5bb213b324f1454712358ef12a096e5b47cd92a05101ab9d09764ea858"
    sha256 cellar: :any_skip_relocation, monterey:       "54770d5bb213b324f1454712358ef12a096e5b47cd92a05101ab9d09764ea858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "753a06735b10587255f57ed889bf54c6706fe023fa77256d5d19b1fbf820ccd9"
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