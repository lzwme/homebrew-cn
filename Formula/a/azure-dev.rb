class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.29.0.tar.gz"
  sha256 "3d72bf064362cc8fc0992ee7bda9c3e2486f3a2ae93b050a6bbc729869c70881"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64fc5859a32fd56f4d61dda49c26b24a7a762b53305ff7219dc0f34a7b9f29c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64fc5859a32fd56f4d61dda49c26b24a7a762b53305ff7219dc0f34a7b9f29c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64fc5859a32fd56f4d61dda49c26b24a7a762b53305ff7219dc0f34a7b9f29c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "add461258ce8b005cdcec2b04e1e763a62d352bfa5548c4ac0a7ceaa90b15a5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1f04e317811374aa21b7a25eb95d6e23d3cb33c758b440bb31ea8907bc58e3e"
    sha256 cellar: :any,                 x86_64_linux:  "2ce0a315abca3427ee6cf87f04ad29983351ddda8b3340fa378e68ed4ebbde4c"
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