class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.14.tar.gz"
  sha256 "1cd6f181c7337203753ae9bc5cb8580e5d09080a7f567caebe8180532e68ece3"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae8e79f56c898dc61364f356f94e3cef971414a81c9484643863a8bef6e4920c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4208047a251b50310b85da5912ba7b6d59de121d3c76d0bd1831dcb82611be9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "298d90042f9880aa6676ff76d209b7f101b5e44ce7b7e0d6a6cc955c10a6ce16"
    sha256 cellar: :any_skip_relocation, sonoma:         "c949a888ce7b79d27dc71a6f008d1b86c11d1979533a068ed37a15a953291228"
    sha256 cellar: :any_skip_relocation, ventura:        "f4801561b963159413c65b6e9b591b0f8ea5fafd5fc61545f0955f313f54a4bf"
    sha256 cellar: :any_skip_relocation, monterey:       "039405cf4b6e44c36bf6143ab80245f48fcb9d522a2ccfd15f94f632ae3f2376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "318b28b5d77c71f5496a6e8fe57758f977bcf82ce2e8dfd08ddaef6ede687318"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end