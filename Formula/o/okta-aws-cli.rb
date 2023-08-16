class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://ghproxy.com/https://github.com/okta/okta-aws-cli/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "9c853ff13237b5afdb14dfcdbb62a34fc7a2cc61e70d23a440fb5f287049b831"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e897d2391615326f14fff747153c7e9725f4c445d083f1d2be751f48d7654cf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e516ccdfa0af55dc15f78d5882a7c502464c68437ab40bf615d2c9a2357edcdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb32aed9e1b8c2cdb8d04ba1399e154bb83fd5dd1b329c30684ac9a5c14cd5c2"
    sha256 cellar: :any_skip_relocation, ventura:        "6ea8171f3fa353c30f53c5480f07c6e97768fdc2cabd95d27bf6e597d5d38e0e"
    sha256 cellar: :any_skip_relocation, monterey:       "cadb3611f7a6d67a57f08b2e03470c8b072a8fa6a84141b12b40e6824104e3b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c32c24aecc8a04e8146c3db7ab703bc7afe2d99e3750c236a489606cb348ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a36953539fa2af31d3d3b3d8470d8a1e2374d7b12531aaac0435daceec9153a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/okta-aws-cli"
  end

  test do
    str_help = shell_output("#{bin}/okta-aws-cli --help")
    assert_match "Usage:", str_help
    assert_match "Flags:", str_help
    str_error = shell_output("#{bin}/okta-aws-cli -o example.org -c homebrew-test 2>&1", 1)
    assert_match 'Error: authorize received API response "404 Not Found"', str_error
  end
end