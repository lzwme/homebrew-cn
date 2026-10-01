class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.35.0.tar.gz"
  sha256 "13edf2c0a1fdd401a08b3c1ff57a61622807a4defcd95a892d5b3de895f2325c"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00650fe3b55cc053d97695cba1243757dc13f48f235051fb50786e9383207c25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00650fe3b55cc053d97695cba1243757dc13f48f235051fb50786e9383207c25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00650fe3b55cc053d97695cba1243757dc13f48f235051fb50786e9383207c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fb54a68d0a33849a7c03fbb102e0b4f73ab17d7d7a51e186cb17f0ccc1964f95"
    sha256 cellar: :any,                 x86_64_linux:      "8acaf91345958b244edba5de1dca4c03c658b99d13a20a9d540ac5fd2e1c6c13"
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