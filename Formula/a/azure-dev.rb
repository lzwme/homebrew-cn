class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.25.6.tar.gz"
  sha256 "2b70998f38c137ba66f223c99c20291edc1fa25cbdb5fc6ae9b7902f52de8ace"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79020e64dc84fa63e2f952fc073e92b12e8d00c47a9d614424035ab14adfe399"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79020e64dc84fa63e2f952fc073e92b12e8d00c47a9d614424035ab14adfe399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79020e64dc84fa63e2f952fc073e92b12e8d00c47a9d614424035ab14adfe399"
    sha256 cellar: :any_skip_relocation, sonoma:        "5150468957def6ada4664e799c36b3e62312bb7a6bdc37e11061d85323721c94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ca12fb596ee0a969e5f12e3628077362548c751433dbd04ffbe0d0d4dc5dfe6"
    sha256 cellar: :any,                 x86_64_linux:  "a33c7d8b98e08fb6ae4eec5ef6c89a69f762f5f725d53486c2c8725b41e281e3"
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