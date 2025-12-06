class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.11.tar.gz"
  sha256 "3de09bf70dba2ed7a63ff58deb3df5219fd715a8177f1d9c9ed06df40f894e9a"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc629e2b7f293577ecbc3ae388af363f67b2dcff8a3b6df006bebf326f82a5dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad9742e6f5d5d4dbf751174f8d74272b766ccdbe992cac89b943e79b6e3f73aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c927e1f918f62f9d46edb370ccdaa24b805d2166dcd95261873392bb61b9dec"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c9f62d22dad91338067803b9e3e087684ed87e05d25cc3b07b38412cbed40e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b2259d89728bd83b93c2a90532b8dd3bde22649439067f9a8be841a8e1bd17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "833a1b77a5e178346f4169514da84529904ad69302c2b902ffe4615d17229fd0"
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

    generate_completions_from_executable(bin/"kubevpn", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end