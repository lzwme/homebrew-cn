class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.28.0.tar.gz"
  sha256 "15d2e8e35d2f5f76b3a6687b688a205caa6868c69ae978fd61c5cd19673018ad"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68d59f4c81ed543f254fd44da0760286dfdfbe0f03f015e0ab33e21e9bbb1ba7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68d59f4c81ed543f254fd44da0760286dfdfbe0f03f015e0ab33e21e9bbb1ba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68d59f4c81ed543f254fd44da0760286dfdfbe0f03f015e0ab33e21e9bbb1ba7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c9a017ac7862fea53ec5e109ed03eea22c82e07c2f8601408746fa9f17974cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa18306eba64bfa661b042ec6189be17aed5657ce7479979fabda182229aa6a0"
    sha256 cellar: :any,                 x86_64_linux:  "3209005a0f9a84d97fe398bc4da24fbf2087e104efd3000fcec271880797ee9e"
  end

  depends_on "go" => :build

  def install
    # install file to be used to determine if azd was installed by brew
    (libexec/".installed-by.txt").write "brew"
    inreplace "cli/azd/pkg/installer/installed_by.go",
              'Join(exeDir, ".installed-by.txt")',
              'Join(exeDir, "..", "libexec", ".installed-by.txt")'

    # Version should be in the format "<version> (commit <commit_hash>)"
    azd_version = if build.stable?
      "#{version} (commit 0000000000000000000000000000000000000000)"
    else
      "#{File.read("cli/version.txt").strip} (commit #{Utils.git_head})"
    end
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