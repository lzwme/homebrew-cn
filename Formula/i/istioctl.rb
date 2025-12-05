class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghfast.top/https://github.com/istio/istio/archive/refs/tags/1.28.1.tar.gz"
  sha256 "4bcf34078d5a24991027b692d2490582648605efdfb34b6c6c0603ee1f0c7735"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4e9beb8344724f59e4d700d62aa0a8f2ec1b225fab4c6966a3dbb60e9383f2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9f5467c7b17656ddb43f9565a92a3d7256ff53de7100bc9ac0ee60af1e5dadb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e618a7243d5c2d88dbdebf72a2f6cdb06fd208a050e1aa50d7461a353f68ad3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a41edd31143d6aa016bbdfc433c1379482d0ed769c1ab01717873b39aeec8ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5df4da4233cac0ca17de76fcb65944314841f2d71f9f3f67afcb22c51bd7d447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ed6d8cfc89cf428c8b44ed449c2540c421a94eeaf6ab63ab9404d296e8b595f"
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