class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.13.tar.gz"
  sha256 "8bf4b952e352f4dda489be2007e42b2b46bfddb47537784cb45dc927dfb682cf"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04c3c476cb044358978298c27e872b7a0d55b88d6a9e6fab77860ec1e19ff97f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04c3c476cb044358978298c27e872b7a0d55b88d6a9e6fab77860ec1e19ff97f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04c3c476cb044358978298c27e872b7a0d55b88d6a9e6fab77860ec1e19ff97f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc54139cf1bacf5b8abf703ac68388ab73c47b19699728b29f29a3cecb3135a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3a89b40c008d91d1565d3bd71a168878fb47fb20965a27a2eab20e1246504ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "685f09612c675d80456e78623f9615337e81dda35fa8980f895bd84ac52a61be"
  end

  depends_on "go" => :build

  def install
    # install file to be used to determine if azd was installed by brew
    (libexec/".installed-by.txt").write "brew"
    inreplace "cli/azd/pkg/installer/installed_by.go",
              'Join(exeDir, ".installed-by.txt")',
              'Join(exeDir, "..", "libexec", ".installed-by.txt")'

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