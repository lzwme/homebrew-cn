class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.78.2.tar.gz"
  sha256 "3bcf8760438848d56087f8e0ff2142419dcb4900986a668e678a0a916d62f9be"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1181594a99241f7fde7921f77d9dcdd881148a6e5b666d438834957a94c320f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1181594a99241f7fde7921f77d9dcdd881148a6e5b666d438834957a94c320f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1181594a99241f7fde7921f77d9dcdd881148a6e5b666d438834957a94c320f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a03a1c18c1ebff99dd276a8831a7924aa6ba4e747a5588a4b1d9eec4d0db3693"
    sha256 cellar: :any_skip_relocation, ventura:       "621b52ae88d1aef213f6aaca619e1b44e1a7c9498f83bf2467a04295f8843908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e489f997d845f4494b4630fe6efc6942ab6ec57cc932c38162eddf550c729c2b"
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