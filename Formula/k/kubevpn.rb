class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "f3a9b545a78d58c52836611c0b3ebbed5df034e1f495966f1b8f681c3730919b"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62d960813dcc23e231b78596c22e9fbbe985330e6d074fda79b775cf57b43a5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ebe260f2804450997b8723dadc59412fac0d79369f7d23c73d7916a1ac0f139"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e082c095b934904385656a662131d5871727931529d1bc0860f6f7912cc4b7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d96b1bd4b07eca236f5dd0852b3218aff2af273f025acd349c766135df893335"
    sha256 cellar: :any_skip_relocation, ventura:       "7cd0d245f988339ad6f38585a507f667f8c5ad62a4effd17d0450a2a67d9b644"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82462b5fd9bbef86c6999a57ff4587a398bf3e1bf7ff1dc5e2f05ff48ba9986e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cce44af6ec710f071de628528876966f6ec6c7469ea1d5ecd31342c3fb3f734"
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