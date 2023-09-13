class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://ghproxy.com/https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "12069865cf4e52eb921dcd62eadf69f2340c731da976aadefc2a813d084da675"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff0cf7da357ebf4b95e6db7b0925bf8079b953c56da4f6227135f56b2334eda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6819ee19f61ed2852a0f0a54cb2cb1e78f89bbe8c7639f90bef101f09831feea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0209c3bef2cbb825c2a8828fa35e1460a40fa5bef18197915ecb17d18070b7da"
    sha256 cellar: :any_skip_relocation, ventura:        "dd2fb9eb51b7225399f49053faa21a03fd24f9e379bf96a6e3f85a97c4d555c6"
    sha256 cellar: :any_skip_relocation, monterey:       "22dfa76f578fc9a99818cc31f892c2689f64d083da47706c51e95b856f3f3c66"
    sha256 cellar: :any_skip_relocation, big_sur:        "be922afdbe4eff23e4f1f6a3b669a373af80e3b4a4aeffc281d4ab257b65b6b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16ecd4e89fb3eaddc124ddfb110b43e91938b2047ea1b3ad89fd72b1790019fc"
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