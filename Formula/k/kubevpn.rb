class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.7.10.tar.gz"
  sha256 "27f8770f400882c7bf6ff93de7597af1e289147a693133e51109c8d089b6756b"
  license "MIT"
  head "https:github.comkubenetworkskubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbc59ab6412102a6ef0aed8b8a48f33f6e89fc189bbc694a8c9ec2c1e52bcde4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aaa0333d33743c9ffe77161911b772a3f9fa7a922ec534b3442daf54d177642"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "820e333ad7715179164988f451da6a78d4b1a1482f1fc0b1a2d1b10d9031070f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0295001f6a420589671e7b5ed96084a05e1359e37841331c41dc2f571dbba120"
    sha256 cellar: :any_skip_relocation, ventura:       "3315e95b34b9b703924d6ed8bd29fe3455cae21cc497f9ed5886dd412fde2593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd877a845a043cbf8722d508517d978b9a55eae82c87c4eb890d27ec3294bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88eeb73f0ec27a445488798d0bcaab61dc656f52ff0da51f36e1818b3c4bb4a6"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp
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
    system "go", "build", *std_go_args(ldflags:), ".cmdkubevpn"

    generate_completions_from_executable(bin"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}kubevpn version")
    assert_path_exists testpath".kubevpnconfig.yaml"
    assert_path_exists testpath".kubevpndaemon"
  end
end