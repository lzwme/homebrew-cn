class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.4.0.tar.gz"
  sha256 "a98afef6ae2288cefccb8d1abdb7d20c351a85801d2d82a4e6ada1d565abf36e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ff9ef67c406dce44e8f42eb4fa3d10d6add278b3a12a0762be37a7915f0b605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc28466d0520b5af066f147460b772bd9158d2c039fa0b5975ed9e5090eeb04e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7132ebd3d6eb745fac9f670ac05786880a5ef3b6e951bf079896af7f8f522c9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a74a9a68e5cd079fe632bf55dd3a0a2e69fc5eaa0a7114da69cd8dfede019d6"
    sha256 cellar: :any_skip_relocation, ventura:       "d6eb59ca8639761664126185acb015f12882adaad7f79da583045522fc16b85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3027ebdbc4b3d430b16f863f49ce36252c48cb797b19987b7ab6c4a77236a5e"
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
    assert_path_exists testpath".kubevpnconfig.yaml"
    assert_path_exists testpath".kubevpndaemon"
  end
end