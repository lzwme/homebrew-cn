class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.3.6.tar.gz"
  sha256 "c09ae72b49e1c21f0e9221e4319f7ca0bc49ad76cfcbc6103147b2e27635de26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "812921ec5d992937ebbe1fd3d6581a5bdbaa0cf5393c8b3fcbae281a27365116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a7bc3b2715e14bb0422d21036dd4e23de3a3e2c4e856c51817c1dd3b6101915"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77970d4148b0096ce7d63331000f4fd0b8ecf2e67c52f1182067bc468c3b8275"
    sha256 cellar: :any_skip_relocation, sonoma:        "635799533e7074653b454032b69a37b8a4d5da1822ec59410d33b5b56d29ccac"
    sha256 cellar: :any_skip_relocation, ventura:       "775c3617ce24144d2aad9ceb8d736bdd12d935f6b84d362f342a90033be6a0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b146969797d6e5e86998c952f0a5fd70d45fb0c4caa3400b1a6f80a4ca00e599"
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