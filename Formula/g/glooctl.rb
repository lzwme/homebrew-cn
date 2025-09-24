class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.20.0",
      revision: "6728da1b3b84b3389e9b6b908a23ceb183f6db44"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b692f7b4bfed7701cb8c1a91e7336ab8d95222a9ea921af19e5526170dfa8cb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3deb60063ea43f1a3387904345cfbe7f745218380370f9524e7025024782cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7bbc65de8021602a84f79a092e1ac00177c336f1804ec2949bc76bef856b50"
    sha256 cellar: :any_skip_relocation, sonoma:        "d673c0feb90ae9ee7dd021ea30ef650dd9b310b641685d1281bab2b00abdb27d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "632bdaa6e9763f6c086881978ab18618b19adea857aa41e355433c4c1d610a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb39722c9d5374827f5ec68148071352bbd79fc24efaa7d52e2471ebc9d2612"
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
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end