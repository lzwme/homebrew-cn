class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.30.0.tar.gz"
  sha256 "f49066dbff1d71ed0af60a78c1f809d708e318869348e9086bb6a692f9325c67"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "697b051f1fdbf65670e5d82475bbf59b7bfdddbc27304a7ef419e4d0f954624b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "697b051f1fdbf65670e5d82475bbf59b7bfdddbc27304a7ef419e4d0f954624b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "697b051f1fdbf65670e5d82475bbf59b7bfdddbc27304a7ef419e4d0f954624b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcedca0f33627c285d673ca49d7c4a570872dd143a38567ffe44db296c7b315f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e80da9147beddbd6242a37bca0f7e488f3d6bcfa8af827fb3308e28fa23aee2"
    sha256 cellar: :any,                 x86_64_linux:  "eac3609e2d1c7975d7727aee5dd01c81cb6e6ab29b112e40616def14c4cc59a2"
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