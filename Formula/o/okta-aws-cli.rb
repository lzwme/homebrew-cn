class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https:github.comoktaokta-aws-cli"
  url "https:github.comoktaokta-aws-cliarchiverefstagsv2.0.0.tar.gz"
  sha256 "95d0d2ff4882c3e6a5dd03e63b985070566c4940b1d72036fdd83da6b07df9fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ffd21384b20ff2584c454cf40bf93273ad1b7e01f57cb2e8b017faa3967c87d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a049e9457c93a3d57b866dba7fe3e22f481680a59025bd631f23345b3692f4cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4153db7596a6cb86803384f7bd3a1879fc50f72ebc5b96916ca3bb9fa050792f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1192215796b6cca5defcb507ce9f95146df9e3da10e8141221cd74e78871609"
    sha256 cellar: :any_skip_relocation, ventura:        "c80bc2e0ae989ca761e071d1ee7d71282ca9da3f1b77c7329f373734743bef0b"
    sha256 cellar: :any_skip_relocation, monterey:       "b4ba9121cb9cc1d41931aea296bf3acf883251a411b031aab5f4ce526970cb39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95dc94b11071c6f4a1a3c655dc60bfde6af78c84f8f00338c8f4a0434173337c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdokta-aws-cli"
  end

  test do
    str_help = shell_output("#{bin}okta-aws-cli --help")
    assert_match "Usage:", str_help
    assert_match "Flags:", str_help
    str_error = shell_output("#{bin}okta-aws-cli -o example.org -c homebrew-test 2>&1", 1)
    assert_match 'Error: authorize received API response "404 Not Found"', str_error
  end
end