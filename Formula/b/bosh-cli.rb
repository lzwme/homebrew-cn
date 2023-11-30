class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghproxy.com/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "09027c404d7194b041c3ce0231dcce456c09ba1c8b714d94c6b663f83ee40fdd"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7babca776746e6ff4fbfa1c509b263f7c776f8a36682fcfa9c649b8cb647ef3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6e714f9f560e2338d69dce6e90084c11d892783353144d7fd2cfe32d462b224"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "490ad7cf9e5f11d8f91ce3ddf565065fb6df9eeaa68024177b7cf9b2a6b4a576"
    sha256 cellar: :any_skip_relocation, sonoma:         "77ab9ec674e4c5080ef39d551a30f7b16858179180166ee43fa77e8c51f3b1d7"
    sha256 cellar: :any_skip_relocation, ventura:        "6411a235713e735d35cf846ef59353c6ceee52c0cbcd053a82ef87223aca04a5"
    sha256 cellar: :any_skip_relocation, monterey:       "49b26ac16b587c640152373dd40abc09be92a8ac6f435f441b27b3b1d4651dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a042702e0a7f6b191e3575785873257cb270bce5b71e84e77924c8f0df650b8c"
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