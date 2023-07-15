class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://ghproxy.com/https://github.com/okta/okta-aws-cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "464e3db0fdb8aa5e2d1ef7bf7daff0fc65e2c3b9084f5f76a4ceaab7f9242ae5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f204d9160e8bd3528fa4e6f9e30e7c6db968ff127b9122116e2f54be7f408e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f204d9160e8bd3528fa4e6f9e30e7c6db968ff127b9122116e2f54be7f408e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f204d9160e8bd3528fa4e6f9e30e7c6db968ff127b9122116e2f54be7f408e1"
    sha256 cellar: :any_skip_relocation, ventura:        "d4de7ff74abe2b47136beb97a0da64b2ada03e8ca490ff7ea277b74dbcd888a3"
    sha256 cellar: :any_skip_relocation, monterey:       "d4de7ff74abe2b47136beb97a0da64b2ada03e8ca490ff7ea277b74dbcd888a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4de7ff74abe2b47136beb97a0da64b2ada03e8ca490ff7ea277b74dbcd888a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8938bd55e024b196de623d91da494f62eb4396d0380733e87e2aeb04ed62cd50"
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