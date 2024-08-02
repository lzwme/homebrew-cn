class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.48.tar.gz"
  sha256 "ae5cf6ebebc296e7b373a6ec5e3d0b1cc20fcb49e213e511b1c8b3433b3f59ad"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b240993478bf93bd2fe1c944eb08107ecd424a4af6cb38b06ce33a4c4389fcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3c1490c7f63e0c6eb89d71004955d569ed9240cc8e5af4f62cbed36fcf25bc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4b713be42663ece80e5c5a2fabcd2cb07e3d91548106a369ec905fff08f93d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dee51b800d67b237bf888b27a2a10b0a12da0e59adcb2696ffbf44723b44793"
    sha256 cellar: :any_skip_relocation, ventura:        "3a708ca2d42a86065d2b73542d1961b3444e6153805f4db0e67dea2159dc6681"
    sha256 cellar: :any_skip_relocation, monterey:       "00792adad7940add91d00fe9d9c729f59803806e3a49e3c542dd0bff21c5d609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41dced3d1f281fa5f43f618b82debb693f7d9bb98dfb862fdad2ad527eb4bac6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end