class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.25.1.tar.gz"
  sha256 "a22e3ba558aeab89d793433dfad69159bb22473885f87bad37e20d9f3b08a7ac"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f27ea17eb1f3dc405841df8608c21d539255e1583ba26ebc513f5b7bb83b1b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f27ea17eb1f3dc405841df8608c21d539255e1583ba26ebc513f5b7bb83b1b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f27ea17eb1f3dc405841df8608c21d539255e1583ba26ebc513f5b7bb83b1b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f76344541880b50905b67dd2f4a43ed08ba174c0d095de2ca83f23bb0d7b5b0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00102077bc52e1e499ce5246862824f16170b3affb2329ef3fd657c690a4409b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65591d45df48c194197a2e71cbf7a185466dd13ed109e1ee95989072f5c31be2"
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