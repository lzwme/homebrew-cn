class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghproxy.com/https://github.com/cloudfoundry/bosh-cli/archive/v7.3.0.tar.gz"
  sha256 "dd36634da2941867aa78b5066206728d42a5120817142e14f9ca76ae2d4f98eb"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b86f93d56b53d0be1c54365cf3d22f21f73d1c80640657d907f25063702159a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b86f93d56b53d0be1c54365cf3d22f21f73d1c80640657d907f25063702159a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b86f93d56b53d0be1c54365cf3d22f21f73d1c80640657d907f25063702159a3"
    sha256 cellar: :any_skip_relocation, ventura:        "8bcef4299eb9185b5f9c681bc9adef35cac88198ba9e6f890da16ed896933270"
    sha256 cellar: :any_skip_relocation, monterey:       "8bcef4299eb9185b5f9c681bc9adef35cac88198ba9e6f890da16ed896933270"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bcef4299eb9185b5f9c681bc9adef35cac88198ba9e6f890da16ed896933270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e0c8366788538b7c8a09f392967f1ecbcc03a0f8247e8753e7e12212cd6ac65"
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