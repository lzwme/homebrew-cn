class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://ghproxy.com/https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "be62e87c41ecee2f39fb78b59e298d26c198f1100d0c017beb26a45094ebe0fb"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73f1a3031fca1347a801c5c1ba0981ba250fb645020c372a85a1cb8d119abba5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73f1a3031fca1347a801c5c1ba0981ba250fb645020c372a85a1cb8d119abba5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73f1a3031fca1347a801c5c1ba0981ba250fb645020c372a85a1cb8d119abba5"
    sha256 cellar: :any_skip_relocation, ventura:        "0a40b23c2a2e958e1291ddafcb3c38c4237dc6fcdb0f5efa6aa7f8debd415059"
    sha256 cellar: :any_skip_relocation, monterey:       "0a40b23c2a2e958e1291ddafcb3c38c4237dc6fcdb0f5efa6aa7f8debd415059"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a40b23c2a2e958e1291ddafcb3c38c4237dc6fcdb0f5efa6aa7f8debd415059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4347ff760a1b1b8491952da1533aa7c7997b37b061ae89bf6a48cd8ed5eef653"
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