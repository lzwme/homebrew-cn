class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://ghproxy.com/https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "264e42cce93c88d7a988fd9b1d6ac1a928cc0ee058d9f6898f58b06e59077bc8"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5077524a8bec69a19ce74ecf551935244210842365b72d4b6f28b336826a0d4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5077524a8bec69a19ce74ecf551935244210842365b72d4b6f28b336826a0d4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5077524a8bec69a19ce74ecf551935244210842365b72d4b6f28b336826a0d4c"
    sha256 cellar: :any_skip_relocation, ventura:        "716c6d0089bc83e5b9c4b96f0e75043176a3566a622e654fbadcf66531d19e39"
    sha256 cellar: :any_skip_relocation, monterey:       "716c6d0089bc83e5b9c4b96f0e75043176a3566a622e654fbadcf66531d19e39"
    sha256 cellar: :any_skip_relocation, big_sur:        "716c6d0089bc83e5b9c4b96f0e75043176a3566a622e654fbadcf66531d19e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b8b7bc85fe5c32c09301398c155b6d60e083d03026e980099941436471c6b8d"
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