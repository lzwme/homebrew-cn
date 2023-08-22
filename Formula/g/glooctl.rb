class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.0",
      revision: "08b8d2e5d451d2004e13f38b5a485fa0b1bfdb2a"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d25716ab4130a6b494ffe70efa1396768228de83aa1a7479545c68922961c78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32250d52f296e8f7c9cacfca1b855170ef9bc3440d94940fefe9758a0a24aa87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d55b76131ef112965ca4ebee98a0387b8dd92d5ebd80f8707329d320692b7a8"
    sha256 cellar: :any_skip_relocation, ventura:        "3c728c239a88b5a9a537b68032387beda11a7aacb0be5e0b8c2e410b0e8dc042"
    sha256 cellar: :any_skip_relocation, monterey:       "824f0b801d914499989586b45e7f4b0d3f2ce36cddf435cea809f409aa0d57c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "79c1681501a615f385ee380df75280287f68bbd9138a26c90cd80321aaa81917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9368178d236e225d463df06a7b0fe75a91989bdd42a7dd313cd6acfb21459754"
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