class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.27.1.tar.gz"
  sha256 "7fbb8ceda2b447e7863e719ce0088440b9ec8f103f35aa92df9d746ef69424bf"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e3060ce0e3381610cffaefcf487337e88ab78d41526c57f5b2364617f1b2591"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e3060ce0e3381610cffaefcf487337e88ab78d41526c57f5b2364617f1b2591"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e3060ce0e3381610cffaefcf487337e88ab78d41526c57f5b2364617f1b2591"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5bc35f62e4656df004a2822efa198e7b8a856768529002d319fbf2f1b8994b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5b9ce893c5f6f3e3630d0d2be12e2042bda98db8cedc2010cf736290496813f"
    sha256 cellar: :any,                 x86_64_linux:  "7290f767248fa5713a2b74bfd38a0cfe7e44fee3b586569c9c4976cd6af05175"
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