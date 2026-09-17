class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.11.8.tar.gz"
  sha256 "b9ae85a779bc2df0b6e7a65ceda4e69340a654b99a07b2d2cba016fb6358b1f4"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "898bb073226344024559283152cba414d1a40cf2147c597f15ac1cc5bda527a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1b333bd14761cc978d606f540de177565c47d8ac1373e8b4bc72b8595b68738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "657986f0b18cffe28d30290b51c68cd3bf6c3d5ff1bd037c75ee5208420582b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3ece48aacc7cd1ae92f7266fcb8dc8e045de13aae4fc3bd0e0dd0a40bba02f42"
    sha256 cellar: :any,                 x86_64_linux:      "a9eb57d4f5e70db34f9e1b73970e2b550d4c6ca0fea282afbfa4026be03c6ece"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{formula_opt_bin("go")}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{formula_opt_bin("go")}/go", "env", "GOARCH").chomp
    project = "github.com/wencaiwulue/kubevpn/v2"
    ldflags = %W[
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