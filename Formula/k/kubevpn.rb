class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.11.7.tar.gz"
  sha256 "e75c4389996ffab7797cb197e4e40e98bdf038a7adcec7c0f67d40db72b28e31"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76f1941b04ce635115763fa7ff4b550047a3f9c884fe13ca8a96dca983373273"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62bc0c337f2f3ef1914b5f9aa68d6fdea070dfe6d69e4c59c7f40e6e8c753462"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6323d15ef7d72170288578920a0e957f07e4cc26ddc7a0f333b8e1efd4fa4461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f0bad34f06d023fdc57a12bd01e1bd052877bcaad10a6ed22b2359a89250c5fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d568100fc9bb44e28b5ed3b7fade19baeb64db68d1c90d239a08c0df1682a4f"
    sha256 cellar: :any,                 x86_64_linux:      "21936e3133a8deeec4334303386cd4e434201c3e43f662aaed41f80e2d4fa67b"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
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