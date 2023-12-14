class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.18.tar.gz"
  sha256 "afedd4a855676bbf0d0f5afe51f0e17e4919537c69e83596ea61a797cf452fb2"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ec9fe6eab15c5e36ca856d3d16b665350c4b1583755ec51196f43562c5d9691"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d029a2c798fe7a45d3d9ccce8273f18fbfc353b980e5d433cb4367abba0ab7b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2019805e68e6fa9481a6802370c2d56e3bde421f35785ebafdbaa7778e797f2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7db36b75a09a80e6156d45ff05f3e29706deabb85a09db69ebe866d62b2918f1"
    sha256 cellar: :any_skip_relocation, ventura:        "8b87eb0b35b848122ba893d8b892614af267d60ca9294d4ece755f0c85d0f6d7"
    sha256 cellar: :any_skip_relocation, monterey:       "9d9de666e8de1c6fb903170ca78fc741005e7e01bba154750efab067325e7ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61738c02648b0d7d1e0e50d21900b87b9fbe86ace9ab72134a53343d19beac4b"
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