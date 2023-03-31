class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "031521c6667143d6f33cf26efcd7ee82dd0adf38534c7b5cb3d893a08220803f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2463da8051a89cd19befed840b89f314b53a6196a72d846e79e0b52d99e11bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2463da8051a89cd19befed840b89f314b53a6196a72d846e79e0b52d99e11bc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2463da8051a89cd19befed840b89f314b53a6196a72d846e79e0b52d99e11bc7"
    sha256 cellar: :any_skip_relocation, ventura:        "a04f046c35579accf35a64510a31b0bb7310a12e460016f9fbf6d77bd9021f37"
    sha256 cellar: :any_skip_relocation, monterey:       "a04f046c35579accf35a64510a31b0bb7310a12e460016f9fbf6d77bd9021f37"
    sha256 cellar: :any_skip_relocation, big_sur:        "a04f046c35579accf35a64510a31b0bb7310a12e460016f9fbf6d77bd9021f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d35a7b53084c9f5fca0b6a734dc39d4d5720728cbb8c01e3e3f0fa05644c2fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
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