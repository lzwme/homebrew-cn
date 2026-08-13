class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.31.0.tar.gz"
  sha256 "dd0cbbbe67d2f9db810928ab55b2facbf7405717923dc521bebd7339d6f64ae9"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8111d108e96514f8d1545d5c2b01276e4f2d93c7786e5ea4b981c03e3448ba7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8111d108e96514f8d1545d5c2b01276e4f2d93c7786e5ea4b981c03e3448ba7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8111d108e96514f8d1545d5c2b01276e4f2d93c7786e5ea4b981c03e3448ba7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0db4887156083aa3836d76e3b7d4187793d9a6e859f4c3ec58477376ccc38ad8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e9f8050bab523a2e487adcbaed9296af6521d353b32420f1792168665fed438"
    sha256 cellar: :any,                 x86_64_linux:  "8c253e813adbb393c812dafb256bb002708523c2f35b75f73db99995f6f960ef"
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