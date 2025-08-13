class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghfast.top/https://github.com/istio/istio/archive/refs/tags/1.27.0.tar.gz"
  sha256 "77705777f33dfe3a63ce19344b3e9ace80d0e8160907b112b9eaf9e791a27a37"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2b7c629866d5f89d3f36feda29d744e9d7bd83635763d0036f270e12ab32375"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d957ca096ca0526d975f3126b08490b867abc7a4a8298224388bf277984b036"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2eb37173df7861ba61b14874fc7f55bcfa18372273ef2e9ecefeb0dea019e620"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c66ecbb55237dddc30092d5da4166867c1fa375557a5ab38338e8f015099c7f"
    sha256 cellar: :any_skip_relocation, ventura:       "ae0517a2b05c6ec91da602f0cedcb73e1bbcc1c94c2066d16188e07b1bc51e0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c779a520756955bd1d2bcabdea72ff9cf9a4c99bcb1bbfa550bce91aaeaad679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a30ecaeffb4fb346f61dc4d3a9c491abc8947e394ba949745c14299e7a69d107"
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