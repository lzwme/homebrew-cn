class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.37.3.tar.gz"
  sha256 "22516048f170b5b592caaec2e1aff7d764491c7ac6e7f09e7ae75b62b9ac6c71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cba72c145d2478be5bf3abd059b8a47e5b0e42e3004213bbd92e281dee56b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cba72c145d2478be5bf3abd059b8a47e5b0e42e3004213bbd92e281dee56b67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cba72c145d2478be5bf3abd059b8a47e5b0e42e3004213bbd92e281dee56b67"
    sha256 cellar: :any_skip_relocation, ventura:        "8ef7e1536ebcc3c250fa386d576eb59267968488664f6efc163b9da71153ae4e"
    sha256 cellar: :any_skip_relocation, monterey:       "8ef7e1536ebcc3c250fa386d576eb59267968488664f6efc163b9da71153ae4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ef7e1536ebcc3c250fa386d576eb59267968488664f6efc163b9da71153ae4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a56e6d2c2ea3b1eaf3b081d65f89e5e4d74d35ce463f65c2a77d6761310df93"
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