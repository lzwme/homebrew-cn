class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.2.11.tar.gz"
  sha256 "ec366fd2ba511ec27711fe2a59c5ac7982e6879bb78c77f94436d4754846b0d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba679f0b3615ac40ee21d54b4e2cd5531701952ed86ba681c7ab9a7b92dcd3ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24df0871241c35120dcc4d58c63b652dfe1e1e85f41fafa2fb949776ac04a500"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "975a77f2674b50f5c0de21ab716387f303b45bb15976ca4094539b19340c6e84"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed51f1ccc6d6c7336fc539df76fb1e9b4f709dfda53493723b1e112076c31740"
    sha256 cellar: :any_skip_relocation, ventura:        "971ae4bd05e97847ef7103b4c9071e7bcb1ede195b1aca4288a5d43bb665d1c6"
    sha256 cellar: :any_skip_relocation, monterey:       "dec03a55ed5765485cf7adf7a2c4e7ef2570b12de3eaf7c14cda835b9a5b0813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a76a8b0dcbe3924f03c9e6feb706c97204510b1a170c36848dddc3722f1dd3c2"
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