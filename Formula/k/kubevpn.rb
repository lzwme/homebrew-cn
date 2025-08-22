class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.6.tar.gz"
  sha256 "5cfc2113a24c13afd09daa0107c955d8a9f554bbb3859544ae44f5880741628e"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebbfbd245cdef75491b75362e94e7cf1b3455d470228a58401586ad6b9b475bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "282fce1e49af35224cdffda0668aeeb3947d54cb6a571b63aad0127c4b1686d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a19e29ea94f16f25d7e3acdbb9a27cee55f30fac7fe59eca96e634e7e4bb0c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c88705a2d8fe26e07fd20de07165e03ec18f8ff7896aea648edfa9f67a6c407"
    sha256 cellar: :any_skip_relocation, ventura:       "51b4211e091f733c2c18c871c21232e162947b85717ccd2462b25acd56966afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dad49c4c27310e99cb5935c069494c7fc5dff52bd34ff8de83500bc3a5e17f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee88e4d100d544b07ebff8ed67d6e9f2b5340689baf72d6a53519decf2f41c6"
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