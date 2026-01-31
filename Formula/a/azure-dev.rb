class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.3.tar.gz"
  sha256 "0b959a43a37270bdb9794cfc182a1916988eb951532fc0b641aa1e12d5fa31b4"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5f9d9b47487890381d8cb98f11db621e74ad44960d5877451785376cb0789fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f9d9b47487890381d8cb98f11db621e74ad44960d5877451785376cb0789fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5f9d9b47487890381d8cb98f11db621e74ad44960d5877451785376cb0789fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "36f42851f02265f7ba2251d9c2dadc20ebe1cc76e4fa0c7e5e57e8884d4723ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c744f5aec765bd555ed56f722f2fd437bd75ebf03dad51c5a4e60920f8dff19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf0b3cefe817d9eb3f7e0fd62e49b492ea1628a1f2ad1d1145f419a8091fba5e"
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