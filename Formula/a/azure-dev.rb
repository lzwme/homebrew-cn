class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.25.2.tar.gz"
  sha256 "8cb96b4a6567fa525f750157d1cf944be25731ca60d86d30a14a20578cc08ea7"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd3826271d25c8e0c8422ee272ba321570afcac174a3bc0f2fe6d490e07d07e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd3826271d25c8e0c8422ee272ba321570afcac174a3bc0f2fe6d490e07d07e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd3826271d25c8e0c8422ee272ba321570afcac174a3bc0f2fe6d490e07d07e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "51a351cdaf6ee6605628cf107f3d583398d1aa40a1b2b4c69f7ad1eab1d90444"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a33ccc548613e3be28c25f020ae5ce35d66f15a838e2477b59b6eb725199dfae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad31af9258faf16eabcb6c023dcd7d75331a5e9fff6067b160d203110f3138e5"
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