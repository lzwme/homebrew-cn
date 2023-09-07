class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.4",
      revision: "40e9aa56de38ef55efc8e6b3561207ba27da2ac4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b17cb2d95daf56c86c4e0fcf0e1c2eccd4efd7f376890e418d82fe3d417d2643"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "662ca18f3dadd6e256edfe5b3ab8d610120bd7fb208b2fc240b08f3df7db8a09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33202f0a0eba39b76e1cb3af6af078a0d9cf34aa83a3d0ab27816efc4af8f374"
    sha256 cellar: :any_skip_relocation, ventura:        "d26a2490c54a195f595df9df07c52d6031c81ce950c708c74ad892b7257a8f07"
    sha256 cellar: :any_skip_relocation, monterey:       "2e51de799c2cf040aea64be0be1339a2436407bfad349f1cd17d8b4f92d3c2e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "230b517e182d0cbd67fcf6e7206f0709694fe443bf933caff37d77a12bac2938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cdfb130b867ad9f44dc754bda7fdb8f87f187c6b96c1a7e2ff0cc89c95b0639"
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