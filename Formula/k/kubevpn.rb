class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.3.12.tar.gz"
  sha256 "a41910292d711d40b2f84509e3e000ccdfc111f872dada99f072540d7a2263ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ca2c174d4c28436c44ee91f59d85fa42a9d72e771334137e47aff5e198e17b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d170ce43e521ea20152d74239d9694c8641204eebb29f81127ab535bf6bf0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "022bb2f6fbae1191bc4a3aa7fb444e80420f3a570e9cc989855395e079add1e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a975647088f2b7b38b18d2b8682043a38822456f12ba53b45d3757a34d6c8e"
    sha256 cellar: :any_skip_relocation, ventura:       "b6444693e9eb91cd246782a415b62f369372eedcca1f20c3dff6ff3742ac92e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20cf837bcee9dcea362232512ea4dfed9bf127d134b657dd57905f3a5da15394"
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