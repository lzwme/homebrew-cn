class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.36.0.tar.gz"
  sha256 "9b6ad5cf0d7a21a5d09b2286042fd276ec286c01d40b348b78f7bf31aba243e1"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41265b4225959a0be2e90a1234e9fd3cc455a9c7ef89a5cf301cce30f1cf582b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41265b4225959a0be2e90a1234e9fd3cc455a9c7ef89a5cf301cce30f1cf582b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41265b4225959a0be2e90a1234e9fd3cc455a9c7ef89a5cf301cce30f1cf582b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "afa09970156acca4b2068b42f9e0987fd483389672aab36aab919d2f2b906922"
    sha256 cellar: :any,                 x86_64_linux:      "0c089cd3b1ab3a8129f0e3101e05dbbb1ea5178e464aba3b6e81987a53582c4c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "cli/azd"
  end

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
    ldflags = %W[-X "github.com/azure/azure-dev/cli/azd/internal.Version=#{azd_version}"]
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