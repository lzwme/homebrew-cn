class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.8.tar.gz"
  sha256 "e48cf6f1256f64bfa0761f776e424c3baccaeb8a2a7542cc58e0fffded581823"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "402aad5f76cdab6b64b19ae46202d83fb4cae696ba84777012d31aaf10883fa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92deb99a70124bb252b04c4afcd46ed90b0dee15e869534038721ec2a9bc96e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56efb16d8a86624f1a72ddb5f27530d50bc994db54172e0506dd9a7bed2c3271"
    sha256 cellar: :any_skip_relocation, sonoma:        "97975ad715c8ce50703257c94e1a224016bb9970de226978ab60c94e8a241598"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2ce1b968fd7618ea1f98049fba902ae6b55e329377c72553b8d73ef76872f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c66ede7ff292e8ed008e6588d5b1a47c1414033c33262a9da0841a44a4bfb9"
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