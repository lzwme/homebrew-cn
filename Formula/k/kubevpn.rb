class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.2.14.tar.gz"
  sha256 "5506e95f26e6ca7d9c5cea0e15b69ba36cd841d03a2e74b9330c424978e30e4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0e591dad4b395a19ef0440c893186c64c5c58df201adec2d2f1342a21f0b0b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bbc57364509523615cead534d6b9c798bfefbf21ea7f7cff0a34348a014b24b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc28683039599ddea184b24ec950cc927032bfb030f476b8baffa846b0d0ead4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6685896e31277bc075854fdab8a1d24f1b5f6733502e17f361e70dc9dda7363"
    sha256 cellar: :any_skip_relocation, ventura:        "21f6e5bb0a9d979e58baf6f5836ed87fbc9249f6ea49a50cce64cf818e2c867c"
    sha256 cellar: :any_skip_relocation, monterey:       "b730630b8d331e9fff83f687c786a5a8aff823e8aff58b983af667edeabb1f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07fcf86a905260acb9087482c7b0bcfbfe53fbd40c85503d1e7324179ea6868a"
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