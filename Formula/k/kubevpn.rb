class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.5.tar.gz"
  sha256 "eef2bdbea8a23cb4bf75812273603afbfb2e5fe79246ee3b957f21c6b45e7395"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23a7ffbb61141cc58317e97b030ae8f5d1e83af45e585dc382836cb6c9525283"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d274ad5349eeb6769446931f0bce33b2bfa7a46e8b12d63d9326e1f38d27103e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "756e3c881e03addcb905201cd1d6b41cdbd1d867f81552e8c91ffa9029629833"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b8cd15f30e42843c6f426f8fe94a49cdf518790b4d5faa4bc7718d6d6aee8dd"
    sha256 cellar: :any_skip_relocation, ventura:       "79088edd77091300f6920f97bdb420f1d7832acf24bfd480c1200842061ef16d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01bdaec1829be4d4b0a3172fccad198e2bdd8af35305f573982f9c5309f29861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224e8fd64e354560be52bce22384584a1e195ed87a416f8f33aa56c8cd5a2165"
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
      -X #{project}/pkg/config.GitCommit=brew
      -X #{project}/cmd/kubevpn/cmds.BuildTime=#{time.iso8601}
      -X #{project}/cmd/kubevpn/cmds.Branch=master
      -X #{project}/cmd/kubevpn/cmds.OsArch=#{goos}/#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end