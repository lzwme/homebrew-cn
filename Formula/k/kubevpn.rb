class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.4.3.tar.gz"
  sha256 "510f97cdc1ad7c6d9283f07904b32b25e7114282072e02cb293c89bf3b07660c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4414f46c2f4569b7bd799377c87bb4b323880ff7ecdaf29d20c893e1916451da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10d135f42eebf10bfe22cfa2e8e8d387aa3434c01d9f072c0360a18de6b7ac1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cfcb198940ff318a010917c251ff33ec45545003b24125251716a483265d0a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0156a4310ebf0e5f69e2e7ccd05e36404694a83fa8241647cff58b240214baf9"
    sha256 cellar: :any_skip_relocation, ventura:       "2d256f98ca5c6c417dfb7f5e99ea16bd72bc9213926bad220b77c15ec997c1b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0b7d43a4358893683afbe57558bbea7c8672234ce0278480f9f18363e584427"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp
    tags = "noassets"
    project = "github.comwencaiwuluekubevpnv2"
    ldflags = %W[
      -s -w
      -X #{project}pkgconfig.Image=ghcr.iokubenetworkskubevpn:v#{version}
      -X #{project}pkgconfig.Version=v#{version}
      -X #{project}pkgconfig.GitCommit=brew
      -X #{project}cmdkubevpncmds.BuildTime=#{time.iso8601}
      -X #{project}cmdkubevpncmds.Branch=master
      -X #{project}cmdkubevpncmds.OsArch=#{goos}#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:, tags:), ".cmdkubevpn"

    generate_completions_from_executable(bin"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}kubevpn version")
    assert_path_exists testpath".kubevpnconfig.yaml"
    assert_path_exists testpath".kubevpndaemon"
  end
end