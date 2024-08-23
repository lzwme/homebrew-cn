class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.64.0.tar.gz"
  sha256 "d43c97cf1765d66d2a6d56468d1e8d23e0f618ad451a5c93e953aa9720d34ae1"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c97aefb9bebf08dbc6178b086be5fee8708ce5807f7928c25a9a274279b9f19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c97aefb9bebf08dbc6178b086be5fee8708ce5807f7928c25a9a274279b9f19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c97aefb9bebf08dbc6178b086be5fee8708ce5807f7928c25a9a274279b9f19"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c72db416c58bfeb64482af65dbad4072477bfc3b7f4ab2c374c67ceef646103"
    sha256 cellar: :any_skip_relocation, ventura:        "6c72db416c58bfeb64482af65dbad4072477bfc3b7f4ab2c374c67ceef646103"
    sha256 cellar: :any_skip_relocation, monterey:       "6c72db416c58bfeb64482af65dbad4072477bfc3b7f4ab2c374c67ceef646103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7da573f3752fc363555ae17b5525f141e6a35cce9ab9738b7124b61e2a3ef70b"
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