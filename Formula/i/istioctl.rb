class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghfast.top/https://github.com/istio/istio/archive/refs/tags/1.27.2.tar.gz"
  sha256 "3fc8542ff73735ce7bb2cd9ad734c1033523bfc1bb253cc3a3ae9cd32bfb7130"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be2ddadd7bd8370ee1f6c8ca08205733783e7d9689fdaba0d38b379a60b90955"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42eff04f08a6348719c22e88fef66b3356ad9bb1abab91869b151a2e2d93f4a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0a2aed64e32e0303031ad611188c4f5f19b0c191b8593aed60b359dcfbd98e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ce4405301031d00eefa46a40fd722650f0a496c7e9a441f1ed34bb77a74d4dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e1f8a5c3d23ff1de05ee83cf17c82a51f5119b495417a32758ac38b9369f6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "690981beb44231960e9c185d7f44e87199eed3300e5e5f1735f538e33ae4ab1e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.io/istio/pkg/version.buildVersion=#{version}
      -X istio.io/istio/pkg/version.buildGitRevision=#{tap.user}
      -X istio.io/istio/pkg/version.buildStatus=#{tap.user}
      -X istio.io/istio/pkg/version.buildTag=#{version}
      -X istio.io/istio/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags:), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end