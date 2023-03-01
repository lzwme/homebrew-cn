class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghproxy.com/https://github.com/cloudfoundry/bosh-cli/archive/v7.1.3.tar.gz"
  sha256 "2e92afd2d920b182d4aa7decfb7359be685d36cdb71114d0edbd9366f4ca5280"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81c29800c78d7ad0cf094ecfd05b0a1649579397c3d3d422140ba65739586bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb22b8efb12b0b8cfabb82b0e6f08ff434dd77ad08d4fe38f8fd41d6bd68936e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23a31876d82bf0766129bbf001602067c02440b17da8b7e031e308a0c9428156"
    sha256 cellar: :any_skip_relocation, ventura:        "7b2ec40966543a1ce83bceed2c414628cde915546ab43186cdf53fd318243582"
    sha256 cellar: :any_skip_relocation, monterey:       "c53cecfb299b3c4b6e4b151e84ea0970c4f4470232acb5ed5606d9c96f3342e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae3639cb329b0d517a792d2abfd0d64d2795d5775a7b9cafba264b7c1db6a43b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c4b48f647c2443fc77babc9ada4c4168fed09d2cd224d3db10e102fc27e28d8"
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