class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.22.2.tar.gz"
  sha256 "766f2a13e94c56fed65059678930c14875ee3f5d04e14ec27354682a797422db"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee312689fb533bf002c3e42d5998d8bdf464b734e2238abc11004194d16628c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84d33cbf0008ea6c875f0386813d06382520095610a5d14a8e3229cbacace072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab6d7331f3265872088f546cb29a26417ee2c844c50049a6b368323d02c8f03a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fbd5769f9256d7a1a26390357ceaa9d88e6068f9693ab863303aad9a9b3ec31"
    sha256 cellar: :any_skip_relocation, ventura:        "ff50be6f567c39663f2633985bcc02e50e8f29ce1d8bf6471fa935654f65a6e6"
    sha256 cellar: :any_skip_relocation, monterey:       "855789cabc307cec70ddcd62ac5b81434e8ecc140096cc3714797733340a89b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944335e13a1df7f473d8fcbd167d9828e44791b74fab930dd1d7fba2793e640d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.ioistiopkgversion.buildVersion=#{version}
      -X istio.ioistiopkgversion.buildGitRevision=#{tap.user}
      -X istio.ioistiopkgversion.buildStatus=#{tap.user}
      -X istio.ioistiopkgversion.buildTag=#{version}
      -X istio.ioistiopkgversion.buildHub=docker.ioistio
    ]
    system "go", "build", *std_go_args(ldflags:), ".istioctlcmdistioctl"

    generate_completions_from_executable(bin"istioctl", "completion")
    system bin"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}istioctl version --remote=false").strip
  end
end