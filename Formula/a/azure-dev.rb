class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.1.tar.gz"
  sha256 "56e784efbb99ca8d5f90033006c8d6449a272e458d722afec68333874a3c839f"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "197a94b3e883424365ee6fc2e8a2a1db6357fd793e8ef2edf225a9039b3f0f91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "197a94b3e883424365ee6fc2e8a2a1db6357fd793e8ef2edf225a9039b3f0f91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "197a94b3e883424365ee6fc2e8a2a1db6357fd793e8ef2edf225a9039b3f0f91"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5e30a757be859d57a9d7ab80d2f232b24c05cc9b7b26a5c9998fbe346ff0cfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45b634aa83ee6823bd1a233f340f8f1396fb9637b9842bcc9682dc57d6757978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07a07b0cee55b0dcc04acc2737e199b2edc2df1ab4f75d0c82da12c9d5c8da6f"
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