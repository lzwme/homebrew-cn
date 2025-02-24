class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.3.13.tar.gz"
  sha256 "02dc0082828875614b7e7c1bbc6685bf588f409a0270ad0e01c416a55f1cbe60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55efbf01fed04eee2258b5db5d7d3af6c113bf0c5dcb5192d45c04bc3d3d90d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "403a4f30f398c41fc9406a91face614f10064fe33db038c5310b40292cfe0e93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4416cbedb6fdddbcc3e412ca77b098e6ca3eb2f638dc0888af5a36d14a577b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bce6d9f78ba5e2286cb606ca1a935fdf8d49a398d4388ebab054a151feebc8a6"
    sha256 cellar: :any_skip_relocation, ventura:       "52de8a5003487701998b5b1630eb9d6b1a1c9241bd99d774638b2968524e28b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "277c109c7e24051af53cc83c36bceb2e33f4678f5938e925fbc8a22503b46165"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp
    tags = "noassets"
    project = "github.comwencaiwuluekubevpnv2"
    ldflags = %W[
      -s -w
      -X #{project}pkgconfig.Image=docker.ionaisonkubevpn:v#{version}
      -X #{project}pkgconfig.Version=v#{version}
      -X #{project}pkgconfig.GitCommit=brew
      -X #{project}cmdkubevpncmds.BuildTime=#{time.iso8601}
      -X #{project}cmdkubevpncmds.Branch=master
      -X #{project}cmdkubevpncmds.OsArch=#{goos}#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", tags, ".cmdkubevpn"

    generate_completions_from_executable(bin"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}kubevpn version")
    assert_path_exists testpath".kubevpnconfig.yaml"
    assert_path_exists testpath".kubevpndaemon"
  end
end