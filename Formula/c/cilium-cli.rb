class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.6.tar.gz"
  sha256 "8f11349a2d817e68cfc40b6dbcc879f3c320f022762730234097d1a313c0fbb4"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc5d0b107bd905e45b82d991d11c1c979abd23bd844b91d00a1b59461e1e2423"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61457e4da3e2e701348c0af301bfb300b09d8ac1000ee6c790b9f699a5ad6d0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e531b3ab2f41fd0f98702536cb85489c8ba598e8bc1bd931f91a27cab7378b8"
    sha256 cellar: :any_skip_relocation, ventura:        "52edb4181e87f7c11d70c027d51a49e02339760f41882e827be77960e56b752f"
    sha256 cellar: :any_skip_relocation, monterey:       "6f9946b1f46a3450df6dc6d02d7f10385e53fb3227a61b464e7000b9be9b53c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e69d24510a6f4eeb614dabf74f4a2e35f401507677e0b39234458d8d9fb20e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "359b79722c3a31d1e0b7eb5752703367d87b34eddce68ce37da1c7b2f66ed019"
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