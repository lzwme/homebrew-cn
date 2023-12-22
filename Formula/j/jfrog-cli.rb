class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.52.6.tar.gz"
  sha256 "5bccbee2233d493fe73033ea9a3d3ed29f2a71b7a1e36d7de998f0f17bdeed9b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1fff8799214355c03e9cf1dcc8e7336d853ef9b49af877c0a54ed0ff27a95d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05bfd1d7b3c8382df6e2eec0020241d1a7a40c0a585eedf25ccc7a6faac0596f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c19bf5728455861c2953ad44331857b166702cee256a508d2fdb22aaa28e3da0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f398deff606b8d3b02a5c9da67e130988b2d96eda9705e5867ffa6818f30e105"
    sha256 cellar: :any_skip_relocation, ventura:        "a0dab5af259f03f5b7c5d4e3f66219a27f86fa95979e68a05c4a8d04b5b27e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "5e5852293725d54380e907dee381ed8b7f471be983827363186958db0ce77912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2082ffe9b884519e5d32895a250ea393be9314b3bd3343abd0ce61d1a0b22dc9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}jf -v")
    assert_match version.to_s, shell_output("#{bin}jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}jf rt bp --dry-run --url=http:127.0.0.1 2>&1", 1)
    end
  end
end