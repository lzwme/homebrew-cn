class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.3.1.tar.gz"
  sha256 "d0f7867e83ddd5dfaebdcf86716845377f186ffb572a490d4262f017ea9a2fbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7591557e9dd297b2d59bf64e01785affe96e835ef9c6806e8dceca51241d18e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae420e7e9028e7e674b875bd04af1a5d42ed7d2b6a409ef3158b84f0c43f2a23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a18930b278d1be3962628e5a0c066e31ae839feadafe290b0e0dbb67e5fc8b97"
    sha256 cellar: :any_skip_relocation, sonoma:        "b944709883e886d92dd11b9a75877fd87376c167b38212bd078a29c93ec68fb3"
    sha256 cellar: :any_skip_relocation, ventura:       "b8fcc077edd5258f7ca4728467db5ee0ab572e9452dfaaa5f59a0bc6c7ec43da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c07d27ba67a16a9bd531f8eaf48dbb5dbfd39ffbd1a0b7810221260bb383f88"
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
    assert_predicate testpath".kubevpnconfig.yaml", :exist?
    assert_predicate testpath".kubevpndaemon", :exist?
  end
end