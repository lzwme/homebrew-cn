class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.32.0.tar.gz"
  sha256 "b80d93c5dda26ef24273768ebc12014b7e142814dee4a673e3f3f517b3dac5bb"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed90bb20cd1adce79f3a410b5576357237aa8d7454fdc832f9e16fc5b048453a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed90bb20cd1adce79f3a410b5576357237aa8d7454fdc832f9e16fc5b048453a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed90bb20cd1adce79f3a410b5576357237aa8d7454fdc832f9e16fc5b048453a"
    sha256 cellar: :any_skip_relocation, sonoma:        "64f45e8775bf30fab8b42261012c61d803ab5882bf0f29c27a0c3be99717d191"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06e66a00fd07417a6ce02738feb2dc82d26e0900b36555e15e16190de2fb67dd"
    sha256 cellar: :any,                 x86_64_linux:  "a657f6e8ac971982d40fc1d3ad7e7f3a820561098edbce931ef8481d19a5fcb8"
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