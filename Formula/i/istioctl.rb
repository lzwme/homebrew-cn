class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.24.0.tar.gz"
  sha256 "495e2f1a8e9b171c426b7f1db2a77230844ba06cb240b1a694b69c9dffc88317"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fa9e780776c71a640ba258ef06b8cb6703b75d84da1b21143774289bd23a42e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b93c9acd7b5f2a82fb3e02fa833ef8afc6351bb69a5e4a13eee9ad47005fe11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "950274711876494d7bba649d229068e70c60642a333e1e405620bdd0672ce364"
    sha256 cellar: :any_skip_relocation, sonoma:        "d55ca79ec819aa6dee39ac0a14fa2f33baafe4d4768504ab1c71a7e5a0234155"
    sha256 cellar: :any_skip_relocation, ventura:       "d6ff9e87076c2d0b52bf9383756f1ea24cdf74ab533fc6008bdb089cb71bad32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aba801ca627647bc3245a3e1b69acf323d1eae709183e4e7dab955aae85e1b14"
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
    assert_equal "client version: #{version}", shell_output("#{bin}istioctl version --remote=false").strip
  end
end