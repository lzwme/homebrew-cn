class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghproxy.com/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.4.1.tar.gz"
  sha256 "b728e048fe7bece13848be9d0ae7952303c7a545d5a84957539d1ae776cf334c"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74410b80c0edf6370de2924d4af75668ace887445c377a075e6985f850e3eaaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51d5afe5b547d8bd73030f6a116469015d55a53cd583c02d1f5d1c94dbdad3d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a1de0e3ad9def56cccabb45100134888b7793f7eda48812a1f0940ca163615f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0836e7c671aa2e5eddb12ae8479af3f43adfb3a21e52588f371838a315267300"
    sha256 cellar: :any_skip_relocation, ventura:        "2f2b973357fdfbe75854992493a517feca1e8152af60dba5540f48d582dd24e6"
    sha256 cellar: :any_skip_relocation, monterey:       "b71484b619437d0452e835fe9b5d5f61f06543afa6f4443b095e66bbc9703df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809690b19339dc3a31ca3196f146c1226a1ffd3aaef5099f923bd3dbbc90b2bf"
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