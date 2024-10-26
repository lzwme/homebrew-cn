class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.2.21.tar.gz"
  sha256 "55aeb7c9590939510480351f1bf744139d3eb16d4b86da92ca6902a32345886f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86c78b184c9c0124c66021d762f930f052593f70774d789ecf5ee67eea36f608"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c47f9655007b46e3f675248f83ce54a4633ee88a41433134b9c9c535088dfdcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50d0e14a3b48a5e732bc198a12677b1dd63253595f4e17499530d5808377366e"
    sha256 cellar: :any_skip_relocation, sonoma:        "81ae4cf8e954a502a30880ae2a0848d428ccdc67004a129723f7e9c25cca4645"
    sha256 cellar: :any_skip_relocation, ventura:       "ad6d2b0e6f8b1f8d358d8575ad0419807ad883b250e771d9532bd894ef932b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceef059f941121f673405ca1dc8d0238eda97ba8e6251045edf9f119d563dc0b"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp
    tags = "noassets"
    project = "github.comwencaiwuluekubevpnv2"
    ldflags = %W[
      -s -w
      -X #{project}pkgconfig.Image=docker.ionaisonkubevpn:v#{version}
      -X #{project}pkgconfig.Version=v#{version}
      -X #{project}pkgconfig.GitCommit=brew
      -X #{project}cmdkubevpncmds.BuildTime=#{time.iso8601}
      -X #{project}cmdkubevpncmds.Branch=master
      -X #{project}cmdkubevpncmds.OsArch=#{goos}#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", tags, ".cmdkubevpn"

    generate_completions_from_executable(bin"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}kubevpn version")
    assert_predicate testpath".kubevpnconfig.yaml", :exist?
    assert_predicate testpath".kubevpndaemon", :exist?
  end
end