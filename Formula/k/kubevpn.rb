class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "391ace74dfbadca957fdc980078fee31f370d768248ce87cac37006ed3e999a6"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6f9b4d8c829dc326268b25d4d31054dc8c9b8dc110f7928c8c152c938c33c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dd4b71e5cae04d27cc9861cd93d23bbd6a71df4286aa500ddbfd650c0d1a7c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "666b817a0e44b42ccb907437492d3250c6b39927ccc2d063bf7692d7fb5e9966"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d708b96a32c6de5d8003a302f01883d7737251e0a8064086c88fd6d5b6e4f97"
    sha256 cellar: :any_skip_relocation, ventura:       "d1c15a4fd811d4f98a6ad9eff0df1d9109155531796b1365a00e49fc4f23975a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c66bb401e2935285d17ab232284950c6ebd693334dcc3fb5e2a43953c4dc747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c74e66659237e1c73dba188d70fab4628a52e5391bb6a82d61bd391bf2d2f9"
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