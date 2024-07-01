class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.cn"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.2.12.tar.gz"
  sha256 "6a8139cd1ff10091d694e74e1376b2d5edbc3f110c9dab43ace387bd4f9fdd40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1915d937505e0c7f3a88aa6e5b6826364c1edc4ce3a1669ce6518888e3a798a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c32c437690564921209c3a2dacb8f0dcb3aa689e0e1ae303f98cfbbe10ff44f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d9c0137fe64be6609f56172e32cae3b4bcb3d10fc27e844139a06a4d04ef96a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba6d20ef9ecabce871bfc60f3ea6535a77dfcc0e0dd6446160dec4d7af66eb4d"
    sha256 cellar: :any_skip_relocation, ventura:        "f60c586d5292c0b8fa1a35169c1e37557d991585be90a1e38da0017adecd3e07"
    sha256 cellar: :any_skip_relocation, monterey:       "0f1bcd04e2516a2deed26a3a4b5752c259cd6448df748d2e70a11360b28c1f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45751e8afdc4cf43455b85b8e16025e06d33c9cdfcc6552451668e33090c9711"
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