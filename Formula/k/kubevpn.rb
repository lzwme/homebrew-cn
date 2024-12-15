class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.3.7.tar.gz"
  sha256 "4438e03a8a0bede0082aafce5e44422cb0edd740502d54876683badb502572c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6208d61809ab08317bfdc418b5e563c9ad9e8e89da660ae8f9cb7c865652a24a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6bc5a31419c619557af42a9bd1cd62b6a5eb220bf3b3c55c7e3f60d429f8f11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2f04513e9b16699c6bbdb33ea7392b517dfb416704fa814f49d589a224d87bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "115e21ff95b1b393ebd0b46d61177e8af03367b38f9b592ec40457a56c1c21b1"
    sha256 cellar: :any_skip_relocation, ventura:       "a808678259bfecd8d5e603048a2bc0ab92b5117121c310d5efeda76d67dd7fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37edbbd6786a422e56c8640b42127e5fc51a48575e6ee0488639b7eaab6187b8"
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