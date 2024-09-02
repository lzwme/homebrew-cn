class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.66.0.tar.gz"
  sha256 "9d68e366b4fcf4f197c4520e9c4114bc8f0ded1175027dba25f16738b6d65c5f"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dc756bb5287d243401ad3dfb8faf934bafba30777b087287ecfc10d69e72af7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dc756bb5287d243401ad3dfb8faf934bafba30777b087287ecfc10d69e72af7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dc756bb5287d243401ad3dfb8faf934bafba30777b087287ecfc10d69e72af7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fedc9f79da97993941631881e886ea9a5d362f25c91b0cdfb6beb9ef26d0d7b"
    sha256 cellar: :any_skip_relocation, ventura:        "7fedc9f79da97993941631881e886ea9a5d362f25c91b0cdfb6beb9ef26d0d7b"
    sha256 cellar: :any_skip_relocation, monterey:       "7fedc9f79da97993941631881e886ea9a5d362f25c91b0cdfb6beb9ef26d0d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9629311c080531d06b93398cda447c3b72cd528fdff139334a5b293e6babf853"
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