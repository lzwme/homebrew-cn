class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.38.2.tar.gz"
  sha256 "f55e2a90c945678726c9292ebc849cdba9559e85e1a19f3018bc135af455396e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4af815735fc8d04ece18ab9aa5a6ca898eac2c8d1777146cd5184932617307e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4af815735fc8d04ece18ab9aa5a6ca898eac2c8d1777146cd5184932617307e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4af815735fc8d04ece18ab9aa5a6ca898eac2c8d1777146cd5184932617307e5"
    sha256 cellar: :any_skip_relocation, ventura:        "4f3c660546f09ae2e29adc5f681c0765f9b22df8df5262f5682ca45a0e00584d"
    sha256 cellar: :any_skip_relocation, monterey:       "4f3c660546f09ae2e29adc5f681c0765f9b22df8df5262f5682ca45a0e00584d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f3c660546f09ae2e29adc5f681c0765f9b22df8df5262f5682ca45a0e00584d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c300ca885c3835301c61a853b9e8fe256e2f590613b9ebe1203cadb9ca16b2"
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