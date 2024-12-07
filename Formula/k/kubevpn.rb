class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.3.5.tar.gz"
  sha256 "e71eaca44e47a3b2294bf60490f53a569b2ac46ac5b91b735ee2d2dbd7a9e536"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57fb2267514c0b72245754f4a35cf5ead29581d3d2fa1ac1acc2e1df15047b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b21199417ab5aef98c51ca27fe5cd03494b928e82651457c39c6851a3d9067fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "170f04f5e3f7e7a6c8b2305d61b2df6d4374c5ea8e68fec76b47eed1fb86473a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3f8a30ab6c5deb95efcdddf4f42a14d44abaca11ddafc578f747ada69c88508"
    sha256 cellar: :any_skip_relocation, ventura:       "068918581c644bc9deda11c3264a4bf06c84f4692babbb3404b09abd1c7ae8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45b64fc1724f9f4000d30333815a82106b41748ae0612bb8f40f503898d807a2"
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