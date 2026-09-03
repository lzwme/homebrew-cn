class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.33.0.tar.gz"
  sha256 "3ee85bdfbaaf7bf9646bb46ca6afc901ee2480668469a7fc11288c373b0b968d"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46e0188400149b6f1ce176b5b1cac626101b9e786e43774b6a4d8654fdcef0ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46e0188400149b6f1ce176b5b1cac626101b9e786e43774b6a4d8654fdcef0ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46e0188400149b6f1ce176b5b1cac626101b9e786e43774b6a4d8654fdcef0ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6562258b54ff78f553ed1ff50c13b11e78975d88249c3c447f6760317b8bf167"
    sha256 cellar: :any,                 x86_64_linux:  "0090da01067ccc88f10b4f7979cb519ad4f1558fa4bdedd8cb16d9145cf87a28"
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