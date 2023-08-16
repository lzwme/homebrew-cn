class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghproxy.com/https://github.com/cloudfoundry/bosh-cli/archive/v7.3.1.tar.gz"
  sha256 "3850e54164ea3fb2bd0a79f5d754401d99df2eaf4ff8747d57d5df11d8b530ce"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15d4083c709df88babd036f021b510350d1cf4a232b86a9b2e64e8a267eeebd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15d4083c709df88babd036f021b510350d1cf4a232b86a9b2e64e8a267eeebd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15d4083c709df88babd036f021b510350d1cf4a232b86a9b2e64e8a267eeebd2"
    sha256 cellar: :any_skip_relocation, ventura:        "7110ac9f91238e386a52ee9c481854a4eb9058d6792cf7f6f79d43bfe2166b67"
    sha256 cellar: :any_skip_relocation, monterey:       "7110ac9f91238e386a52ee9c481854a4eb9058d6792cf7f6f79d43bfe2166b67"
    sha256 cellar: :any_skip_relocation, big_sur:        "7110ac9f91238e386a52ee9c481854a4eb9058d6792cf7f6f79d43bfe2166b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18323f9c3fb8dd1924ecf9a03410d6252994a360d55d4d1db65a9adba7b8f39f"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_predicate testpath/"jobs/brew-test", :exist?

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end