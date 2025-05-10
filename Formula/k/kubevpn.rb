class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.7.7.tar.gz"
  sha256 "fe64007df8550de18b5358bd0f767c88accf7da3f068b74b21eda9d0673b503d"
  license "MIT"
  head "https:github.comkubenetworkskubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e69973b89bae2e327e0685a575db39b02c00fe5dd5f24fa49c59a6d37036e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae10e62c889fcab222fab00ef4e50393d69f46312551b049199d40ade7bfb621"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a68b8918815e25187521d02cf559f740257db843530068515f153d13a0472566"
    sha256 cellar: :any_skip_relocation, sonoma:        "1399ab1db5480e72ea16cff863d00a2432d19ea7a021da34452c73553041cef1"
    sha256 cellar: :any_skip_relocation, ventura:       "70977edba89edb6a0755931f364955ace82a7a6a8f017af95a2802fe45246d8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79f7e4fa628b3c8d31ba12947bd62aebffaba16fa08157c7294a39d8705aa942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ac1452083238a17e768b58f5b1b1c1e8dc92385e7b939a3a925f71b7d66265e"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp
    project = "github.comwencaiwuluekubevpnv2"
    ldflags = %W[
      -s -w
      -X #{project}pkgconfig.Image=ghcr.iokubenetworkskubevpn:v#{version}
      -X #{project}pkgconfig.Version=v#{version}
      -X #{project}pkgconfig.GitCommit=brew
      -X #{project}cmdkubevpncmds.BuildTime=#{time.iso8601}
      -X #{project}cmdkubevpncmds.Branch=master
      -X #{project}cmdkubevpncmds.OsArch=#{goos}#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdkubevpn"

    generate_completions_from_executable(bin"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}kubevpn version")
    assert_path_exists testpath".kubevpnconfig.yaml"
    assert_path_exists testpath".kubevpndaemon"
  end
end