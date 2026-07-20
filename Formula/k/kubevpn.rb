class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.11.4.tar.gz"
  sha256 "73d75e90554b5141a7307bd358705833eee2575fdf5969e1264cfb5d12cce834"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75185e0fe2009e5ed8886dc46a6f9e9a963699d12f18430647d5c91124dd0e43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "926979fac6d3cf77b3159cd9eec7d38c293f75c3c99c93a757ac23000e6d4bdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa5dc80ab5298281f104e06dd1e659f1377db128f3249da7ecd57da4902e52e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bda63ca89e48ac982a0c7ad6251adb7d2bc0ace4eec0a400691dfffb4734088b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51b28349cc1a89e79f1374c9de88989e910ce850e688bad5f7ac7fecb4f932c6"
    sha256 cellar: :any,                 x86_64_linux:  "71790cdc189cdc1c68f1d60ba37200a200742fd438740b4b23684de6726ee943"
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