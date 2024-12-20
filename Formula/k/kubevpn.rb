class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.3.8.tar.gz"
  sha256 "02adfc632b41fe32ec90e4e78c85f4b93b55117a072d118583a9f712fdcdb2b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27bb76cd03738b7d54531e170f963bae47d8f6c91520c0097b6d6a7263898a61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee1df13d17030cba0458f390902cc7b2e68fa72ad12ed13a4025199b0dbf63c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "caf17d42d33e7bb4c9f2cb8089d017c8f8e59df493a5084870bfa6040deb0087"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b3f872bd24cf6d22aef18cbc5fcf9218d781457de0af38e4d919195a38be71e"
    sha256 cellar: :any_skip_relocation, ventura:       "8b1b253190675ece346a0bc766720a69f08ea8e343448a7dbbc7d34c09cf3bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bffe2f93f26abcb7786ef8543034b394b0e28477f61ca095b02d3d101e2bd0e0"
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