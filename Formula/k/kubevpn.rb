class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.4.2.tar.gz"
  sha256 "fe42c5a315d9c80c60ccd8354a5701deda1bf50c5583bccc29f1b897dcb788c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "642e4f4ee12c8ca2d03ece0d754735c6f23aa6fffaa7bba378bc1260e1f2a001"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1bc365d58c339ec5a5f4c9814cf84e28d06c7cf0e163514ac1dce25fd703906"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "380abadc1c78b0353c6d6ca30fadabcb3c13d8bb4faaa1e61a71dc9bbac3a728"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bb95ddbc08c71b5c932d5589913506b9a9d6f566c5b6f0ccc160ce85b771c61"
    sha256 cellar: :any_skip_relocation, ventura:       "bf5068615d309c159dee86998965c04e7e7bad8d9ebc20e9b82dcf693b77415e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aecf4821553b631a4601d51c15d0349550db55920e203a4702db50065ddd67a"
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