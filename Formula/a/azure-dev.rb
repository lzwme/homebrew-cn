class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.37.1.tar.gz"
  sha256 "a24a98c689de0d305e5e5a52cb6dd7923e8d654feee5a6e62c4efa81b1eef17a"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3dc89ea0aa856992053ea13143fa1aa311e379c7882efa3f7fc32e31cba12f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3dc89ea0aa856992053ea13143fa1aa311e379c7882efa3f7fc32e31cba12f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3dc89ea0aa856992053ea13143fa1aa311e379c7882efa3f7fc32e31cba12f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4b81119c449c2666c00832806b97a409dfddc024fcc294e3b38bad7b682bfa40"
    sha256 cellar: :any,                 x86_64_linux:      "76fd92b9a540fcb24377ff1669845878832b3fbbab88743275aa604f90dbfb5b"
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