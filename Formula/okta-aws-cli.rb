class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://ghproxy.com/https://github.com/okta/okta-aws-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f8ddb7933cbee81ea5b78557708cd297c548ec633b8663bd5f67b981f8425dbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3b0b89fd9e05755dc7d79592c7c6923ad774f522d3b9d009ac3ebab924e14f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3b0b89fd9e05755dc7d79592c7c6923ad774f522d3b9d009ac3ebab924e14f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3b0b89fd9e05755dc7d79592c7c6923ad774f522d3b9d009ac3ebab924e14f2"
    sha256 cellar: :any_skip_relocation, ventura:        "8e158d95d1b218ca49f05b8d9ae80ee3ab20a6d61efc13011f156cccfc67b64a"
    sha256 cellar: :any_skip_relocation, monterey:       "8e158d95d1b218ca49f05b8d9ae80ee3ab20a6d61efc13011f156cccfc67b64a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e158d95d1b218ca49f05b8d9ae80ee3ab20a6d61efc13011f156cccfc67b64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a03f1ea2f40ba0f913a0c7de1c4bffc00420585830be3cceae77ebfc5e1b18a"
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
    assert_match 'Error: ValidationError: Field="Org Domain" Message="is not from Okta"', str_error
  end
end