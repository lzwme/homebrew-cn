class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.7.11.tar.gz"
  sha256 "9d97aab1522fee563f419974725dd28d824c33203ae79dae14956849e368a455"
  license "MIT"
  head "https:github.comkubenetworkskubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91b6b8fa0da792ed2193d7bc5feb35b675e6cdcf3e696b2f8cce962c06c3002e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8fbcd58fa340ba758dd49a8f13f9fb0e82dd50015a9a76e5eb4f0f14027958e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d4df4a3efcad164e62b8fe20739af3c1ae47f081cdb854e3b5171ca0dc72458"
    sha256 cellar: :any_skip_relocation, sonoma:        "041fc5e8025d1290a93442e411604dff71e5ad0f582392b31c3e76e6496a0a3c"
    sha256 cellar: :any_skip_relocation, ventura:       "bcf7065d2ce6d72cbdde92079233224129182c75905d6d7f77bbfceb12bbec67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d01bf7fd7ed3fcaf58a6a0dbdbad8c677774299fec7ba8adee37cf42abf35b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdbca2549286d7eea5788ec59d607ea77a6a178779ac4b367c6a8b7fd3eaa459"
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