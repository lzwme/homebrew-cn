class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.34.2.tar.gz"
  sha256 "dea91c4b991d64d566e4108887ce5ac9186b6df4e7da97f6ec0a5109aeaf0a3e"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5661338389b931d768e52b58270ebbcdb1d4667d031088127f7a51b25c9242a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5661338389b931d768e52b58270ebbcdb1d4667d031088127f7a51b25c9242a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5661338389b931d768e52b58270ebbcdb1d4667d031088127f7a51b25c9242a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b954af43286e223fee4bbe0373930e3d0cfc5b40f032943caf90c48d3283dfcf"
    sha256 cellar: :any,                 x86_64_linux:      "2a6308ac9dca462698e96c7a5ba18e6da9e7741ca24420184df8dd5dd75dcdf7"
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