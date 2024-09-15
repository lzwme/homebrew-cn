class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.2.18.tar.gz"
  sha256 "bb5c2f19d5dc256794d118a36d9ff2ac7382c38fb7b8ac376e037ea50d99a7c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a4ed5fe18276664830115f5891bdd77da89e1c75d0f289c1c71c3e211d03b271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1e534b5f7ec7240900cf60b714078437b8605f195da81f64060cb0c84041730"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95f72ab88ce032cd83ff1866f3024119163d4d61b771a5aa3ab33d741bac6f67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84f63a07bf9ccfcdf03df6e3c6092bd2d838c0aff2d8e15eea766aca1916a145"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d286cb7124bb1de1e4a9a1dd5546d659e20148d4417a69431e0d36bbcb37808"
    sha256 cellar: :any_skip_relocation, ventura:        "6009f099391d1c56310390899e65b1cbf1c57a6a09748a64827d7daf6e3074a6"
    sha256 cellar: :any_skip_relocation, monterey:       "ea9905751ef5c016879af60ccb55f77f94989e9efe09267493a866bc78eb431a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2729148906821b485fbc6a70ebff8d97b907e2970edd2a7c15598740a3006017"
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