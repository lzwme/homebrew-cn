class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://ghproxy.com/https://github.com/kubescape/kubescape/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "4b095c736aedf844ce6b41d70e2e7534940211e3bd4944a7d765aea2ffdcc6c8"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ef83d79449cfd63b6b26fb40385d2dfaebdbfc7d5bc9d0cc43cd0844f1ad22b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "706d8f7b64ea9ba720545e8fab92e3e1520efa547571dfeb17a158abc6bfa75e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f01dd9894fcf381803621a485a1dabae5ede7cd6abe50e176c4721f1b4dc04f"
    sha256 cellar: :any_skip_relocation, ventura:        "8d8f3dd7a37d321e0aa8637d7d44537d0d6ab28a7fdc3dcbd0524548d98b9473"
    sha256 cellar: :any_skip_relocation, monterey:       "46ba8e20f7f93e109827e11600a3f62912c775ac6f51888be5cf231e74180393"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a5ace66c767f797d7d979db699148a81e6d5467de9ca695b52256c869398622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce2ed16b6ae2b9adf3f4a6e06c3f49937d96e927779ac191f0165a3b47d6b749"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v2/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://ghproxy.com/https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end