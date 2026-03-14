class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://ghfast.top/https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.9.tar.gz"
  sha256 "725686d4825b974031c8f68016ac763fe21f2ce974ca170216706c2d1b66e808"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8a9275f41901ed3df93b64a94738eca7e124a4fbb03f23251ab3e7805adbc17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8a9275f41901ed3df93b64a94738eca7e124a4fbb03f23251ab3e7805adbc17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8a9275f41901ed3df93b64a94738eca7e124a4fbb03f23251ab3e7805adbc17"
    sha256 cellar: :any_skip_relocation, sonoma:        "85489e3e12c40a5ac5314138a3801f6d4c8e40b81b8b42f44c0cb6ab3d7c3049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1d74c211840f64f18e275c6146b7f8f1d1a922461073a086fcd7a160828ccc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6567ef8ff790b21e01365b0d156b34b44aabb4de6e89e1def9ee69711deb9ad"
  end

  depends_on "go" => :build

  def install
    # install file to be used to determine if azd was installed by brew
    (libexec/".installed-by.txt").write "brew"
    inreplace "cli/azd/pkg/installer/installed_by.go",
              'Join(exeDir, ".installed-by.txt")',
              'Join(exeDir, "..", "libexec", ".installed-by.txt")'

    # Version should be in the format "<version> (commit <commit_hash>)"
    azd_version = "#{version} (commit 0000000000000000000000000000000000000000)"
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