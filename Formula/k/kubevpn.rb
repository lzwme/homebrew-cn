class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.5.1.tar.gz"
  sha256 "3e6e45c422e946502b540e53d4ff2d56524d8cb9ba0a9fc402420b595500f92b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73cf5f4eb3d1a5879e9d841436c30131395c247739bf0c35a49244bac3665748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3038ee6c1f1e1da7fa08454a22dc1db2b1f6aef0cbb4e1a4e8d29b88aa4eb73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48618c8c9e722af1f0fe5eeb69836980637d660edd0158c3d2b54cce5f1bfa84"
    sha256 cellar: :any_skip_relocation, sonoma:        "b111f160f449ba541f4ca649c4e14da2913b3a415c0a596e6d434f3fc2f8904e"
    sha256 cellar: :any_skip_relocation, ventura:       "2a248034749dc088498fc4ea5d84f6ba4f0ae5a19d0eaa5a2a21d9e0831b27cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deb6d719d2dc3813ac96c488243be13d28ac10b1d22adc207bf141c4cb8d05a2"
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