class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.2.16.tar.gz"
  sha256 "ea4925baeca731d505ceb230b946af54dead70052777f3166b55308ba67ac909"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc37f0b56b7b62ef5dd9e7bb8568ba5f54f84b0760b841c8ea67a01aae30269e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4f2b68ea3cb04529224d5ad697402f02be51276a5efdedf83f21b881a5d6d4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be1a4bfeda48b9a0335f529115d896b285724ebc255105ceecc323b55e0339c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "558f0a12755d1dd3e1ad82cd5095424a731c5b8fe908eb722e2a6c439c290ace"
    sha256 cellar: :any_skip_relocation, ventura:        "7b1ea1cf8b32402aa6e77389568ca9b5f805475d800187f3d9665e130708dc6e"
    sha256 cellar: :any_skip_relocation, monterey:       "e8f6d1aa83f1566cb2e2080b3c897fad72a810bbfd48261eeb866b8e5b0fe866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c81e81629239cb6cb0eb15f1e6428f43061f5ea25925528845c8a72c16f9a4"
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