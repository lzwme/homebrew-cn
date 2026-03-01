class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.7.tar.gz"
  sha256 "7ff8848120861b702377172f63961f3d89f615b3d72b867d60dabd6b4ffdd536"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c52bfa8582687fa8f9ca6dc957ccbc0a908a54e82ff6f9f3333140add061cbf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c52bfa8582687fa8f9ca6dc957ccbc0a908a54e82ff6f9f3333140add061cbf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c52bfa8582687fa8f9ca6dc957ccbc0a908a54e82ff6f9f3333140add061cbf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6579469687d630e690069e354a2181f402b86161f68a8f39d777791dd91dd10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2064e01c76dfad9c3506ea49e86e77b56b6f3cd2ee615dfaa6303b3d5654cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "929b26cdf3a919e8bf506296b91dd1dc9abf29332127532bef743f13d72a42fb"
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