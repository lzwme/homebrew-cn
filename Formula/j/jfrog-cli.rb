class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.78.6.tar.gz"
  sha256 "8e65ea2ddfb7d33c63e977836b21228d85a9b01105c5d07e8efab6529a8c8fa6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f3ed60434ac14443734417d5f2cf9b700e9a1fdd0faf2f183d6918f2f3ef36d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f3ed60434ac14443734417d5f2cf9b700e9a1fdd0faf2f183d6918f2f3ef36d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f3ed60434ac14443734417d5f2cf9b700e9a1fdd0faf2f183d6918f2f3ef36d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5bf4451568bccbcc23b0de7782c86b6dc794aea00c3091e1b9b8fb1660d82b3"
    sha256 cellar: :any_skip_relocation, ventura:       "e37a138233c5254e47bb1b66089e9568b1c0e0b8f6ec86ae78a2126100ad20cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d02f4307bee6c3e928d1f4475f9f58b6425e29254848015c6f16b6a7cb753b04"
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