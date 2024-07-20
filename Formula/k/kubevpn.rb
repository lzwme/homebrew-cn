class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.2.15.tar.gz"
  sha256 "6f9ce194eb0ca3bfeb18250647ebdb3c106c9e03b67743fc165b8e96b17951fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68eac83bf755c3e1c4f17fa0a6294ef6d0972fd1b42ff56b22b7d67d3436887c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "431d7073c8057cdf3f7db64bf7089b006f3edc2a0722cc37a6fdf27d1598dbbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c62d52e8d052a157df008e2a7f28fcf53166b7bcbb7e7f60044dcb5289b0c246"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ba3c84a19219a63609e939f15e8e254f888966603884f2dd6162223dcef183a"
    sha256 cellar: :any_skip_relocation, ventura:        "6af481c16b6a367cbbd9e3f042009899c61672005549b1c43c571e81ede6c1f9"
    sha256 cellar: :any_skip_relocation, monterey:       "9cc8707f67f86fab34362d80585ac339d6dc2f32c9793cb1d2f95a4928468bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97691192c4375be94be508be671690fe083e5a48f76aad91fe8a9c313dc4f0d4"
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