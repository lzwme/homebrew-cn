class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.25.4.tar.gz"
  sha256 "c536652b376ac0c7045ee46834d838e21fe4c3e6f175b3cfe773522db706c628"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f89aa742e3fd4e834271e83e7cf015f7dafa484a644ca17d36cc8edc8eae77f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f89aa742e3fd4e834271e83e7cf015f7dafa484a644ca17d36cc8edc8eae77f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f89aa742e3fd4e834271e83e7cf015f7dafa484a644ca17d36cc8edc8eae77f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0903eaf74750f64567b5fdf9bbc756cd13ba574005e55c49855f128e0113c1c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe92638a4b9fe15ebf6d5efaa5fb70631a77df5cde4afcb095b92da52d281e13"
    sha256 cellar: :any,                 x86_64_linux:  "ef72d04c3819ca46b2223f732fa36e38dcf6e196fbf463298cb705753629fdac"
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