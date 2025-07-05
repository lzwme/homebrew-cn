class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.21.tar.gz"
  sha256 "49e0d9a9c92eae31dbf25c155e181e6306afe6d46ebb95770d5f4a50b16db114"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b28dcfc4f19974c991c7c0e739cb5500a6596f92bcdd78bfa39d8a1779d20cdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a394b41eac790de6edd127b20fe7c59603b38f14413235a31ce21dca3bc3f9d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3504e33e8eab9bc384543cd06c212c0a7d5407d364db6bfc5807f16ab4b6057"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ce28a12992cb6ade823f2c95ab2c0baf87522d06207fddfdd5794ddfb550d0c"
    sha256 cellar: :any_skip_relocation, ventura:       "7d4203eaf217da1dcc61718d098037f009123abb4498bd47834e4238d23f53ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff603a6fb983f10e15bd5c2dafbfafca8c898fa5f5e9abe64935d9d15db138f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbaac881e156a29661f385b50402aff0f6af917b52ec33dfa8c7cba8fa6aa8d3"
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