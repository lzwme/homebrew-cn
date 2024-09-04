class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.7.1.tar.gz"
  sha256 "04f8e4dd2ac1e4170719982048fb712d7f4a3f2f3e953b694778a46fe0d3593f"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8536230e1ac88b89af51d71faf29210729c3af256d34cf0a242006c8ced8c38a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8536230e1ac88b89af51d71faf29210729c3af256d34cf0a242006c8ced8c38a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8536230e1ac88b89af51d71faf29210729c3af256d34cf0a242006c8ced8c38a"
    sha256 cellar: :any_skip_relocation, sonoma:         "91dc4b3ec8dd148c4ca2d29a999772c5f82c658f7c88b8dd0b17b95ee96d966c"
    sha256 cellar: :any_skip_relocation, ventura:        "91dc4b3ec8dd148c4ca2d29a999772c5f82c658f7c88b8dd0b17b95ee96d966c"
    sha256 cellar: :any_skip_relocation, monterey:       "91dc4b3ec8dd148c4ca2d29a999772c5f82c658f7c88b8dd0b17b95ee96d966c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb80a3c8e6671c979d012923b7210582f9ea3f695c2988a3e9dfea50ffed7236"
  end

  depends_on "go" => :build

  def install
    # https:github.comcloudfoundrybosh-cliblobmastercitasksbuild.sh#L23-L24
    inreplace "cmdversion.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"bosh-cli", "generate-job", "brew-test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_predicate testpath"jobsbrew-test", :exist?

    assert_match version.to_s, shell_output("#{bin}bosh-cli --version")
  end
end