class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.8.tar.gz"
  sha256 "0f41fa40a5077aeb67da09d238ea8c6eb18645b2c1e0cd93cff1992de84c0423"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fec09db6b72570be23cebc5ee69f7ffb7af743e7a8b8ff94328aa619f19bd57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fec09db6b72570be23cebc5ee69f7ffb7af743e7a8b8ff94328aa619f19bd57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fec09db6b72570be23cebc5ee69f7ffb7af743e7a8b8ff94328aa619f19bd57"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bd61af0c3717949027481207a4652180eba859a4ca3437ccd42240dd3103865"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6943900ae2752b59e2a9c2aaf871682d09736cfa902840dbfeca40fcd1909931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb35d94f72eb54606b256e7692761643c63251b8ca08d67d63addabf0d3e9bc"
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