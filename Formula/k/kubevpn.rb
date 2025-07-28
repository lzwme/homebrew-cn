class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://ghfast.top/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "cda33c46988e9ff00b8f51f3b4d666dfde39e27a51c67c68dd2badeb1f70f211"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa8777e785426497fd05544714419360ea8e80a3818d445669e92f9a80702c98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0db1a8871e58656248c7bceec0c2450b5bde1c5423c8e6aebc8b0203ff79526"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23162d40c897e619bb5a8ce767501aa3b6e0da27314d5fb30d6de84b6287d8e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f0b8b9938225b5c718bec69352631d8b9ed864cd34cd6b79cc8ccab3613b3fb"
    sha256 cellar: :any_skip_relocation, ventura:       "fa8c8e5903b5dbb8ef1aeb93e42d73aeb12ed7ae7b2bc71ef1cec68af7e76721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f82137f7deabaeb0828532f27d0f154c145e4b8a79a4ce160e1ee5468bad728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5365c387489e1d72b099d9260e431b0c00084392579ae802049554d7606f73"
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