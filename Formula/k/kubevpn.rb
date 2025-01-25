class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.3.10.tar.gz"
  sha256 "c2c636257061ca192c83083f9b82e879d8a3cb746198ed4f19feca196ffe0cca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a893172c6d92c03b6920e08c777e78f7322c657fe2d26c341f955335ed346d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05e611f89c0474ff4bc3789479a9f5bb66d13bc3d0d1b13ee1573c85ab4dcac0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd3816b418d73526ee8887656881cc403b40d4a14ee17dbb9f5cc7a87f8fdcb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aabea34c05f3c4b2e2787aae46ccd491630e396830dc0a97638cae68d60a7a4"
    sha256 cellar: :any_skip_relocation, ventura:       "e90c15a1adcf866af5883077b6151bcd9824d2685cbfb454840fa101838a49c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fc0b07b3691c5308e64bc8e4d9544fcb0e5b95986419113cecdc9b1b77329a4"
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