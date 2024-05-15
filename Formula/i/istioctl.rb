class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.22.0.tar.gz"
  sha256 "949bb140cda875a786f50f78394fac6ceeea13220d62855a0cb5f2304a6354be"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96b77ff6a198263caa20fddbbce5417e3c45b3117e513c33730202735fc22d15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b596e8de8e79c73131f2249565728378763acb939e42a45fbef2ec229afbecca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5ea8a06a0288ce838903749a34f6d3aa81ce2699ebfffcab1bdd021d04d298c"
    sha256 cellar: :any_skip_relocation, sonoma:         "186f34faa0620002bb851faa14bb4f710ea8ec8ced3ed9289c14e9d451128fba"
    sha256 cellar: :any_skip_relocation, ventura:        "7a4df58a34f6e3457bcfc4f4ef55c93d8bc499a162e4131ae09ad8f304a05bce"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a6f6681ce75d862cb10955abf4bbff83bb484ed2b574ea9e86a5d50b911f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b2a72d7bb206a90d418f39b164875248042e931a4190d7b0833bff83cbc1bba"
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