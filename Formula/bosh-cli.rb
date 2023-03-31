class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghproxy.com/https://github.com/cloudfoundry/bosh-cli/archive/v7.2.1.tar.gz"
  sha256 "4c9887c3744c1e63b571cab30c3d26d1f5fc8a924d36a47e163a0aa65f64eb97"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee6c2ea112c44ce093691e57de37ebf6ec65428cc19cc124d0cc321acb0af8db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee6c2ea112c44ce093691e57de37ebf6ec65428cc19cc124d0cc321acb0af8db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee6c2ea112c44ce093691e57de37ebf6ec65428cc19cc124d0cc321acb0af8db"
    sha256 cellar: :any_skip_relocation, ventura:        "a99583fd096baf3daa3717376efce1dd7f81b40d9edfae75a69087221413576b"
    sha256 cellar: :any_skip_relocation, monterey:       "a99583fd096baf3daa3717376efce1dd7f81b40d9edfae75a69087221413576b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a99583fd096baf3daa3717376efce1dd7f81b40d9edfae75a69087221413576b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "086eb2cd0528d5299ec4a4c7ba369bf9d0d9669523f62b9007488c44ca31ab8e"
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