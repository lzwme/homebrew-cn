class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.12.tar.gz"
  sha256 "e4eec8f0316cff8e05f8383c401f5a5ea98586b4c6aaf149ad23d4a07cd30257"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "026738e15fd99152b5fdd3a66584b9a76aa650bdb036705e927870bde575d825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "026738e15fd99152b5fdd3a66584b9a76aa650bdb036705e927870bde575d825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "026738e15fd99152b5fdd3a66584b9a76aa650bdb036705e927870bde575d825"
    sha256 cellar: :any_skip_relocation, sonoma:        "db4cba5e7bf080c2bf13bbd5be26cc223758b8e377bcfa369e116783764e5d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1234feab71e92bcdc3423fc90fc3429e86c0dd98309e506b62c19c83c826fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c9a1ca047a2ca337f51a6ee358a0043b30ab719d3224f4a7c1be3c8395e2a4c"
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