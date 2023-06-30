class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://ghproxy.com/https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "6770f231e0e672e979e5609e79704b3f1497bfae4d43aa162bce1d85d85bd6ca"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59efecaba4975eb4ec08a84f99dd71b516fa9572cd23dc4def8a238672942baf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59efecaba4975eb4ec08a84f99dd71b516fa9572cd23dc4def8a238672942baf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59efecaba4975eb4ec08a84f99dd71b516fa9572cd23dc4def8a238672942baf"
    sha256 cellar: :any_skip_relocation, ventura:        "4509e76a48c926c15bba6e2d271d6cc8e2b9263c64baf9000a42c248e6064b78"
    sha256 cellar: :any_skip_relocation, monterey:       "4509e76a48c926c15bba6e2d271d6cc8e2b9263c64baf9000a42c248e6064b78"
    sha256 cellar: :any_skip_relocation, big_sur:        "4509e76a48c926c15bba6e2d271d6cc8e2b9263c64baf9000a42c248e6064b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f93d65e36bd22e01f1ad8ad928973dfc616d4c0b37db5fe5ea280e28e32e0e7c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Authorization completed",
      shell_output("#{bin}/oauth2c https://oauth2c.us.authz.cloudentity.io/oauth2c/demo " \
                   "--client-id cauktionbud6q8ftlqq0 " \
                   "--client-secret HCwQ5uuUWBRHd04ivjX5Kl0Rz8zxMOekeLtqzki0GPc " \
                   "--grant-type client_credentials " \
                   "--auth-method client_secret_basic " \
                   "--scopes introspect_tokens,revoke_tokens")
  end
end