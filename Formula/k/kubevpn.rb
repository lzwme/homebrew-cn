class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "ad11aa9e0ca0f94d08f4e3787a0fde68f3d3f9bdec8576bb4496b1320beb3e66"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb7f9d044d0a7cf37054788481233f03c5199d3fc254a0c6a21a4331999ca750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4021612d2a7dce6614af65f9764188c9f79a1947b133140ba605b2a73e2e4fee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4585974cd11bf8a283f6cc7365f78ac6e43663d6634fbc0ca16c761ca5bca4e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb6002a2e9c2a3f7bc1f362f9df70e7b01d27cf6a80ff34fe6cdaf209f1690a7"
    sha256 cellar: :any_skip_relocation, ventura:       "a3050d0e26c9c2a4b75cad76d034e3537efaee948a7f05a1b9f9849d9a26232d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d974ec9051d58df132f6c3c2549230e1649e6d724599f617ac7de6bc2cb105a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a9f8adbb52aa8370153e9df01af7c03f766dcebf5cab89b3d6125759090e9b"
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