class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.24.0.tar.gz"
  sha256 "2715250f87697e1bdf92919e2f69682251f5469aa07d1ad8a08e5709f6228cd2"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "012c685620906ea38026b3d5c27fb858ef0e8d403e58e7deba24f62b3982b2da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "012c685620906ea38026b3d5c27fb858ef0e8d403e58e7deba24f62b3982b2da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "012c685620906ea38026b3d5c27fb858ef0e8d403e58e7deba24f62b3982b2da"
    sha256 cellar: :any_skip_relocation, sonoma:        "d66c835e077f6dde1b082cf6bc2a6d70be9806f938abeaaa147944ec2abfc119"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d377525985a49452260e1724e4f48170213e98c97206bdfeb49683991b3a20b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58265d256442278688d126d0c64e6e464e0723f5d33ad578d260a60d25562c6f"
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