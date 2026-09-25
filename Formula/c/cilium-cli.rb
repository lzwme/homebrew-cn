class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghfast.top/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "3c9c6a261baa52ee3365c41e6501eef956d046133360685ab2b5fc00bad7b683"
  license "Apache-2.0"
  head "https://github.com/cilium/cilium-cli.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88d87b3d14834c7e0158103b09d32e0ebfb56e2a998d659beaab1ca346e7eada"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60349dbb2732308c6db983d991832069525a24e0f2ff7d95d1b3ffd4a13297d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "108c6a68604384d11e0928c4bf4bbc1af1d14d5f4e7655b9e823f43e86384ae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "064b1624502b19264562fa08f6ac54d4e002fbb7ce3a5704b63574261108f660"
    sha256 cellar: :any,                 x86_64_linux:      "301b52c9d558c52e6a7fbf1b2e8d36cec4ea1bf7f138d875e4234332bac938e4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=v#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", shell_parameter_format: :cobra)
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end