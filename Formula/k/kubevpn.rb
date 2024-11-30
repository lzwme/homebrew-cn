class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.3.4.tar.gz"
  sha256 "d0e1b41d4013c1e21d58b71fc9b14815ae8bd0565d0bbfbe85fb8326c3be1960"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7b703759ab39035941b63438fedd70a4a3432bfdf2d946f7c3e1d32546e5233"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12e02f4b944fba76c76a9c6e5ab5dd6d9c32b742febe9f4f97aa50b3eca6a60b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2a70d201c3952cbf41859c3fd5e6b2974390198dd463a92530fa39239aa2f3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4123a9224b951d33e1965d145d1f18cf2dc56f2a7247becfa0b88b46e593273"
    sha256 cellar: :any_skip_relocation, ventura:       "3f12f86f0af2a2553be34e550364f16efe2706f3d2a2a48e2b346ded5a451bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bf94e8fc939753c781fa9972a74cffab17e5e653b914fd451dc0cff8a439ca8"
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