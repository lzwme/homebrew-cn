class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.7.15.tar.gz"
  sha256 "c1a10d8ad8ba4b63195f3b7896532d7e1e135b4423a1450baf39c3356dba566c"
  license "MIT"
  head "https:github.comkubenetworkskubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a9cc9430fd4ea59b37e01589db89784b143cb88a90f20252df437ada33f3e5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "673a8a8d15b585f169fb732230695cbe1a8b2528c2e60c58eeb6f0324a1759ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bea43dc8025a548f618a380705ee76cfde0a095a14caf61159c79a04f879694"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d6e972682b6b9f882701560c9ff95601304acff6c7b1848355bb6df65c8c1f7"
    sha256 cellar: :any_skip_relocation, ventura:       "a07006c193c072c8452ea2efabf9f0da78bfcbf93079c10308efd0e241128d23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48f5cbe847baa4330ebfe73608ea3366d34c36a849d76b3b86bc9a994f4434eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb6997374e8b782abb61a36e4c109912fa098319d1771cc3ba162f3b48812a5"
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