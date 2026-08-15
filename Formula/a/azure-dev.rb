class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.31.1.tar.gz"
  sha256 "35e076653208e858f33f32a32117d2b32cc843cefebaadc7441126fe093ece41"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c58553a9be79d1a56213b37b42b23e1b9eb87bbb3348be3079306b7c6625302a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c58553a9be79d1a56213b37b42b23e1b9eb87bbb3348be3079306b7c6625302a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c58553a9be79d1a56213b37b42b23e1b9eb87bbb3348be3079306b7c6625302a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4954c9d7136263a2def34cc5f5c701e4828ae25302aad0c109cc0be1b3ed8e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c58c4c5dfa043e24f8a75180670148df16c922a54a718fc80f68f7a8f6d84eb"
    sha256 cellar: :any,                 x86_64_linux:  "1dd45ddb4d08a6e03b7cbe4a7d58bd7979b178a48bc27bed2c3262698497dc01"
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