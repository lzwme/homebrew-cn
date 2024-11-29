class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.72.1.tar.gz"
  sha256 "8bfb1010b06c57ebab9ea2977f2810a00041f80fd9796b37616fe553a57ffbe7"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f21fc57d2468f4426f3dc163d11912a2d540db5062997cf9d67216afdba98815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f21fc57d2468f4426f3dc163d11912a2d540db5062997cf9d67216afdba98815"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f21fc57d2468f4426f3dc163d11912a2d540db5062997cf9d67216afdba98815"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e842396facc7ad5b2ae71543460bc0e4800e985ab1ccec1fc42ed77901b5656"
    sha256 cellar: :any_skip_relocation, ventura:       "1e842396facc7ad5b2ae71543460bc0e4800e985ab1ccec1fc42ed77901b5656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5c998c39ccbd119e161e28f42e8b0b99ba03cb509f52087af5c87c5ddbbc0c"
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