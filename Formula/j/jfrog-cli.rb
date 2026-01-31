class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.90.0.tar.gz"
  sha256 "97f5f8dac247c663feee142e8b226061e42bbfea89ff75c1239ecb9104d962e6"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61b8f741fb251d8e13f2622259199fd58e91c4a9291f2bd26abb5754ced43b1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61b8f741fb251d8e13f2622259199fd58e91c4a9291f2bd26abb5754ced43b1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61b8f741fb251d8e13f2622259199fd58e91c4a9291f2bd26abb5754ced43b1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "29c642d44b681a5cea40bff2ae9436fe03bd78493fbbddb54eafadec06bf8969"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f71b319ba51497672043d383f193ee700cabe8ddc5e795fdb84cd6e13df757ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae95a568b5de35b5b0c77b17aa06a193995262a0151a220efbc6f1c984d5012b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end