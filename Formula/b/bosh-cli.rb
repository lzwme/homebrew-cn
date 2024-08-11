class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.6.3.tar.gz"
  sha256 "308dd3d063fba1abf2b79f0fb023baffa843e67c74eb362fedfbbc8f2f61f9d0"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b6fc951bf2c52f097c78ea31738ab17f0a3ec9efaf605c48fc4dfb911d839cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6eafa0a2584b40aa99e661d484db0e772c7fe86254789f8a90d1048e0a0d169"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13e36d9dc4c00b7991aa6288f7e86a7647684ee7ff29c24ee7f36fd8c8384863"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0a1ef4bc313093b01916e250fdcdea0bd881d23d796851292f1b5852d76fedd"
    sha256 cellar: :any_skip_relocation, ventura:        "e0f1a8774c9cde72a1d3e4367430ad530b155641735d4633ae4224d742bb28c7"
    sha256 cellar: :any_skip_relocation, monterey:       "00c92bd92070edfed18860e0e38cee0c784557ceb9b497a73d10807822175dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1b2194681b58290693b84ada1a7fbc687e78ff9687e9993731a8c7188cc0a11"
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