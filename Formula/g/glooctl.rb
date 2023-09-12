class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.5",
      revision: "2873e9828b29229060c3d1b3bb353db12d40bcdb"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c30241effe5129d5f6747c0884c967c7b862bfe68b7744d6cc8b7f7518ddbb0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9b35f641b6b95ecc83ce72ad41c2e4ec0ee2970571a7399415c981337379faf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45e6e397764d76897489e8e06942d2d2cf3053d3598e879bfa8dd3115dafe169"
    sha256 cellar: :any_skip_relocation, ventura:        "82d6f2ffd14a89b4ed419059691dd81fdf084642f287bb4d41686841a1569c27"
    sha256 cellar: :any_skip_relocation, monterey:       "6868af323557fd175932da7fa7eface1ac0b2d76a56b6f53a30bf342d69f2e9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "114fd2526290cec39daa110d5ebb6ad6fda56050adbdae5ed42db7753d8821ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3534b025487f2591bc2e919e2bb4443b855d9c991d1799710a485e5d728883e7"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end