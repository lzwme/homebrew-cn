class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.35.1.tar.gz"
  sha256 "1768c2cadcfe338eb1d81561acabffa891ee502caffe5018fa11c92e2bfff71e"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4313452e5630cc9338f1be14468d4663d899fe58a03aaf4e2568aef52f9a44a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4313452e5630cc9338f1be14468d4663d899fe58a03aaf4e2568aef52f9a44a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4313452e5630cc9338f1be14468d4663d899fe58a03aaf4e2568aef52f9a44a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cbb1181da6242f6da2dacaefd3d692e6352e0fe89d7ee0fff35c04647c206464"
    sha256 cellar: :any,                 x86_64_linux:      "04b6cb7438f077168d3bf625b71ced53719a157cc370995f9aa7e24ca869f09d"
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