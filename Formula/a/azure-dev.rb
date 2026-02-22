class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.6.tar.gz"
  sha256 "94d8542080c16eee2132d79c98334bbe3b6fc1068b53f6bd4525c732e93dc6c1"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3083b2f3821024efde47559c6074ab11a3f084ef4fb3a87302dedd8a1e0d5367"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3083b2f3821024efde47559c6074ab11a3f084ef4fb3a87302dedd8a1e0d5367"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3083b2f3821024efde47559c6074ab11a3f084ef4fb3a87302dedd8a1e0d5367"
    sha256 cellar: :any_skip_relocation, sonoma:        "81110f5d1d5ec7bd27fa8d73e35f2987544e7d218c7e686ccb25cf8419619af8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36278451bbf3e278501da4cce9eff2a6dbe5c47c2f3a01029407dafc5a6ed623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e0ba7034d8c3c032fbe1d9701efefc9c85f673aaae94e5161c4dc47ddae3436"
  end

  depends_on "go" => :build

  def install
    (buildpath/".installed-by.txt").write "brew"

    # Version should be in the format "<version> (commit <commit_hash>)"
    azd_version = "#{version} (commit 0000000000000000000000000000000000000000)"
    ldflags = %W[
      -s -w
      -X "github.com/azure/azure-dev/cli/azd/internal.Version=#{azd_version}"
    ]
    system "go", "build", "-C", "cli/azd", *std_go_args(ldflags:, output: bin/"azd")

    generate_completions_from_executable(bin/"azd", shell_parameter_format: :cobra)
  end

  test do
    ENV["AZURE_DEV_COLLECT_TELEMETRY"] = "no"
    ENV["AZD_DISABLE_PROMPTS"] = "1"
    ENV["AZD_CONFIG_DIR"] = (testpath/"config").to_s

    assert_match version.to_s, shell_output("#{bin}/azd version")

    system bin/"azd", "config", "set", "defaults.location", "eastus"
    assert_match "eastus", shell_output("#{bin}/azd config get defaults.location")

    expected = "Not logged in, run `azd auth login` to login to Azure"
    assert_match expected, shell_output("#{bin}/azd auth login --check-status")
  end
end