class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.126.0.tar.gz"
  sha256 "784bb49b17f74b70a2a28752c843ac7b7b1bfd4bc3bc43a29d622e0933390ca7"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "402e16c1c0f74d20777b6c626b2f42e18aee71b9b97489b32136951d516b3b3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "402e16c1c0f74d20777b6c626b2f42e18aee71b9b97489b32136951d516b3b3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "402e16c1c0f74d20777b6c626b2f42e18aee71b9b97489b32136951d516b3b3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bde39ec0d7a49e096ae289908b7664d8536c269a7619911562137639f0e35eb7"
    sha256 cellar: :any,                 x86_64_linux:      "307048edbaabf7b8dd698c86676bde05f3678c020c567ff6673f1e3f7fbffef8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"jf")
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