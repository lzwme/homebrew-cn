class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "8aabd2bb82c126d6bb5e92c11d39ed98fc34bf315a27118f06e74a5edd4f776d"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45ae3f6a9e89e1896509329f46ab7b04112c02d6802dfd9050d2381c63f95472"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0194cd27a69ad38fbc7194645d6cf3a8662f2dbd287e8f30a403c716a78b71e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f3474feb22525e7f2f653021a826d3a1bbf559b1438fe0ece8537aa2a110777"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2c646fc0c09dc376a9330d079cf06355533aa1bb29cb9dfbfc715e7d6a202a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed73f0cb41f7fe98d8d282fb6c2e668576d038d929e4da1927cbf7ee44fc5106"
    sha256 cellar: :any,                 x86_64_linux:  "9d8abb9081554d7e09e5df1398cdeee3c69222221009aa851993d4fde935d802"
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