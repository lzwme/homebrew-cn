class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.2.tar.gz"
  sha256 "7cbb601840f5f7c4c7dc97b8f2a5a549da901170e218a091cfc22116b8cb5033"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc5a11f3e43490abc0a7fafde5e2f52196d0f9c0251df560866055acebd80dd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5a11f3e43490abc0a7fafde5e2f52196d0f9c0251df560866055acebd80dd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc5a11f3e43490abc0a7fafde5e2f52196d0f9c0251df560866055acebd80dd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "94a2314a8547b131c7fb2575717117284ec5c69846f9d8366e9e60f9effe030b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e70fd69ef22b8ab397cd2c8aae252d6191efe425fdf85d82e1e826f0b185621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90170c9064d1d16fef9af9f5b4cfe23b64c5add77e502037eba65b4e4b3822fc"
  end

  depends_on "go" => :build

  def install
    (buildpath/".installed-by.txt").write "brew"

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