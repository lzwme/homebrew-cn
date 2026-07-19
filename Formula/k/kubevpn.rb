class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "325a818dac164daf626a0ee4ceaccc4e8ac7e8e87ad823fc95c1192acaef40e8"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caeb072d78585ed016b958632eeade8320f2db1243464779550351163eb40e6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e671a199b107a30ee467e82ca4020645ca1f4e38bfa4413e3649ac527bea157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dfadd7d8eddf8ec8e43c7486b2ec44d50ae795403c173fc8ac111dcd0f6d7ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "f64867ab7159b237593f47610a9baf50fa3aafb1a94e07bb7ac82bbf3f4e6708"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "512f5066d2627b4d495671742d8bb9138c43af5815a88d42dd1d2a5a414733f4"
    sha256 cellar: :any,                 x86_64_linux:  "0d7068dedbae2bf1b21749ceb0d0893b335f2c261218975b09a61c74ee5f3299"
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