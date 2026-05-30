class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.25.3.tar.gz"
  sha256 "c1d53cf7306100dbcc770e42d19d3477ffc90f2f7217c12115fd2dd031eebdf6"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7628b4fcc315b3dc70a148ad7482ef88900dbfca97487f6c56ad2657386b880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7628b4fcc315b3dc70a148ad7482ef88900dbfca97487f6c56ad2657386b880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7628b4fcc315b3dc70a148ad7482ef88900dbfca97487f6c56ad2657386b880"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6df8b92aa1d631971214e9cf1aca14487517640c3ae3ac17f59bc103da51063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6ff8e1458c59963b2c668f824ed75a4e4925f349fefcb6cf9aea224790de05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90beb54d3b70c5b66d5e88f2a4e09944aea3599bcf18b3005da79f6c8f18c9dd"
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