class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.7.12.tar.gz"
  sha256 "47f0a03b371c6256690a4e47474e37113d915e1927fee3cd6b993be70b007ae9"
  license "MIT"
  head "https:github.comkubenetworkskubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ed76bebb2d2c08dc0803df69a8893721fd8084f7e4834cb92b4dbb3a913ea1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10a4604000079d04ca72509831b7a68866fed68b284c1801f13bc1cc2a8f22b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b28468ba982edecd19c3f77b4ccada2b6b4b414add372b2c2bbfffa7775e8e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "77d8347ef49eb6292f33fa60107bc1db0cfb006f6f773dc91b91269d9731ff8a"
    sha256 cellar: :any_skip_relocation, ventura:       "c7656ecd7d6e08f0c0dd26c9b01b95082ee46402974c70fb4f329e505881a739"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9271a58123acbac1bc8eaf878009b4413cb9901a738fc4026762668809c54bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18787cfa2bb5d6f2d6d5521f93c330124224186e1ed46a5166e5c28d58e34222"
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