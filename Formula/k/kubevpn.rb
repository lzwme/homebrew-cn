class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.5.0.tar.gz"
  sha256 "b36fd17cb05834d7132c9a3fd8afd2643e6a62d005f7ba58d6001928715b8af8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4af07e0ef86b23a5f6ef5eb6d006973dcf412981fcab057358f2b6cc0783e43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03aa7fc912a8ac14128e79ba83fd74d43a1a6738fceab8ac2e5d5e87f67c64ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41273cf9a2fb2c5756594c0725fc8b29d8fd654e69140adde19232c5f0524bea"
    sha256 cellar: :any_skip_relocation, sonoma:        "199dca74c1aabedabc30cd0e2f8f22a6a241468c911965141d6b6057a4f221d7"
    sha256 cellar: :any_skip_relocation, ventura:       "8994c195355c69d3bdaa92042239a9a1526802aa8feb7fb29ca01048fafbaeac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d81b90c3054e1c1e3cf9af851ccdbf20b5444fc6a2b559d71195a3d1b2bd6f"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp
    tags = "noassets"
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
    system "go", "build", *std_go_args(ldflags:, tags:), ".cmdkubevpn"

    generate_completions_from_executable(bin"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}kubevpn version")
    assert_path_exists testpath".kubevpnconfig.yaml"
    assert_path_exists testpath".kubevpndaemon"
  end
end