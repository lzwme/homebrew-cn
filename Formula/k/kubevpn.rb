class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.12.tar.gz"
  sha256 "1affbdc008b613b3cb0bb31119df7d4d3f7e10dca37e4007fc3e9fd19da93f88"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e62c60cce29c0e9ce01a1559d05b6846bafbd2351ec29eb71cc60eb07270c1e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae7134096f9c3fecf30169eedbfc0c56fbab7c6127b830876c20f940a3c2ac3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80d232496153737b50f1b5ea652a6f4e22893638519c74b9ff7e0f85573cecff"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e28d413ef8e126a1cbf3fb3f887e86cd115740f3067887a0f5d79a0ece6f646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "423f984d69b20337d373bb08291d26e341bc3ae48e3e07418bf80f6ebf670923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3376cc431efed8e83990dc35723e247669c7d0d03f891da3838cd09f2db29ad7"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    project = "github.com/wencaiwulue/kubevpn/v2"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/config.Image=ghcr.io/kubenetworks/kubevpn:v#{version}
      -X #{project}/pkg/config.Version=v#{version}
      -X #{project}/pkg/config.GitCommit=#{tap.user}
      -X #{project}/cmd/kubevpn/cmds.BuildTime=#{time.iso8601}
      -X #{project}/cmd/kubevpn/cmds.Branch=master
      -X #{project}/cmd/kubevpn/cmds.OsArch=#{goos}/#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end