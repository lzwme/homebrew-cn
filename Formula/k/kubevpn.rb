class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.7.20.tar.gz"
  sha256 "359c30835c702453ee890b690991be9adba4fafc2808219e2ca7da216ba43f0d"
  license "MIT"
  head "https:github.comkubenetworkskubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3e97799441d2d17ede216e0fb3aab111e39187c6a8a9c8e7afbaa121f04a932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a423df2b431ead75242ded8f8bebb31bfcc9178bb26e189924a6c8973dc7ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36c71505488142a0a802498bba952d779a9a80b106331af188ca11e358c7fcea"
    sha256 cellar: :any_skip_relocation, sonoma:        "faae1d2af1b483936991b1d89098836a25a43186a84165a07b2bea697b988547"
    sha256 cellar: :any_skip_relocation, ventura:       "821232195fba43dee07ab58efbfed9bcbd41659eff5df08b4a15ca8f66c62e7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b502aa67f12c04adba6065dd9dec905c0150ce0e1df7fb32f73f80ae5cc8b3eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb179966fa71ae3bf46016e3429b89702eefdbcf8b448999125fad853d3eea0f"
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