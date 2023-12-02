class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://ghproxy.com/https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "0bb9ca27f9db5360378f9ba2c2bf4df0ba91f346f4bd9130c434df7079412251"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca4d113c60ab2e48cc926efc454e6a50ae3ca67ca1926e9d9d2d7e64c4b1a5c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ef09585cc7cb321aa42bf2062e45c9d962465d2bcca7b0a30a21d9da90ea510"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cddcc2589e041fa4888a282ff76ece5d6503ed7395a73e9ba99e7fe6e629cfdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2dc7e3567bc38cacb1d304b9a06f0870af45afb9f19c4349de427052f336665e"
    sha256 cellar: :any_skip_relocation, ventura:        "8bf066ba97cffd0d82a6bb8446e0fd10d5e0f3e04792d84e91ee5369df702183"
    sha256 cellar: :any_skip_relocation, monterey:       "3fbbe927e0b8cbd64678777a175f253dc294806407a71c4f9ce046934da401ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "565a8066d1eac681a4829ebe4014dd3f60965f39dbb785b09bfd615ff7c34ada"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "\"access_token\":",
      shell_output("#{bin}/oauth2c https://oauth2c.us.authz.cloudentity.io/oauth2c/demo " \
                   "--client-id cauktionbud6q8ftlqq0 " \
                   "--client-secret HCwQ5uuUWBRHd04ivjX5Kl0Rz8zxMOekeLtqzki0GPc " \
                   "--grant-type client_credentials " \
                   "--auth-method client_secret_basic " \
                   "--scopes introspect_tokens,revoke_tokens")
  end
end