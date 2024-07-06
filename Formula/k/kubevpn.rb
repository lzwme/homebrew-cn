class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.2.13.tar.gz"
  sha256 "2f21b7188333a2cdaaa23246b3b2d08e6e4a236b6d28c2dc85c306f690e57e0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0842067e972a76bbc9bf15162e6c427bb98eb1f4337d1e33f38a7936126b0d25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a6593d839e7f10489170c44b4ca4032d13663c5b505f4b68b5c5e211de73c42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9c47b9e89c24a97c11ce49c7546286f82e0c27e8d8405cd462c25b91b4eef5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaa94b31c97bc457f98c76bd4ad9468eba960f356610ae19477b86c05f60da00"
    sha256 cellar: :any_skip_relocation, ventura:        "6df470fbe03744ce24f6721df4e62d3bddc40689a84821c42170d6d04c767084"
    sha256 cellar: :any_skip_relocation, monterey:       "789d474522c05bbb1b551b7563a18ee2dafcc31e590360bb4a8f5b033a04f8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2112f97ed93ae78257f8e3553528315b53b753a8148e8a921bebbe6cee7d04f9"
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