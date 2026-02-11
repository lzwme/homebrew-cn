class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.4.tar.gz"
  sha256 "0212e680f76c3fee5ff3c33a7afc1998d113b8178f58acba3aec5c847f588d2c"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "764f8e0cfd2517caaf570c54163c91b24d98de20e9eab19222603079a5363d67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "764f8e0cfd2517caaf570c54163c91b24d98de20e9eab19222603079a5363d67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "764f8e0cfd2517caaf570c54163c91b24d98de20e9eab19222603079a5363d67"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aafa2cc8f7d40fac4ccfffd89a903c0b46315249adda9d233185ac74d68d3eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164de052bb7b0bc848f6337a8c6072e76416df848a066ae970712a3af5690166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92fc23195d024e2ca304bc1b6728fe901c6f67b4c8082aeaeb93810a1e0e3c5c"
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