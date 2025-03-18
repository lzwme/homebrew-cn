class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.4.1.tar.gz"
  sha256 "e734f22be1b18f379916059300a448a64ab84f8b9fea896750ef9cc3bd002315"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9f807b32245fbd8d9754cb6bb58e369851ac0c4e5d1cb0b4d958c29bb97ba1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b8a68419bf69937e88a4da864860714be16a5b870757c26741919e8dd337fc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49d1bea9b4c9a6e4b5aa269aac80281affb2640e93855f36fa688f7a116e7b22"
    sha256 cellar: :any_skip_relocation, sonoma:        "45345c411c89d3545626049d31fc28bd0a1e7dec6689516553ca80bf3664471c"
    sha256 cellar: :any_skip_relocation, ventura:       "68812a6bcc8b26e66cebc919d702347851c17d667f30414dcc2045dcfb8c180e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5165de9fc2dbaa9bcab06ef72a67bf6e14156fb5f5b857a2f37d6e7a51952a01"
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