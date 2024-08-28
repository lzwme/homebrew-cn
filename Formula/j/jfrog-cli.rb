class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.64.1.tar.gz"
  sha256 "228edfb705204d7d015dc48cbd4d0afafa86d11d6dffa466da38ca3aaba86dd7"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "861a68004da7b3df02ab34a4f7ce2f4b943ba9e7e74fd11874fb6a6f5aed47f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "861a68004da7b3df02ab34a4f7ce2f4b943ba9e7e74fd11874fb6a6f5aed47f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "861a68004da7b3df02ab34a4f7ce2f4b943ba9e7e74fd11874fb6a6f5aed47f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6293ebbdf3b56cfdff2dfce9b89daf6c025a2222413dba1a01eab35f53aa0585"
    sha256 cellar: :any_skip_relocation, ventura:        "6293ebbdf3b56cfdff2dfce9b89daf6c025a2222413dba1a01eab35f53aa0585"
    sha256 cellar: :any_skip_relocation, monterey:       "6293ebbdf3b56cfdff2dfce9b89daf6c025a2222413dba1a01eab35f53aa0585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05b61ecb840260f5ce3547b54c72e5982c3fe904abc62c1f856e1a1a4f6ef2d7"
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