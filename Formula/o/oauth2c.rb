class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://ghproxy.com/https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "28434a1ae19d558addbd08847fc7738788caf9cefabb7e17eff90f8d78e235fc"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3daf699362e2af4cb6da652341c3857b7e5fd631b382e73f46da9174d889d6d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70c7ce56758b6e67c0290ccd22d9d66ce54e074be622386fdee913a72f5e54d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bfc89406e4fa3f29f41722af6059d529c0cd08068638c3fd4d26efe8140f0f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7121ee838c4d4c557d52c8f9edeb3bcf26e0f15893a26ac07e24dc1c8752ffd0"
    sha256 cellar: :any_skip_relocation, ventura:        "d3765eb3acae75857730951d37eb4d2f691f2a6def8783f303ad2bda2403f039"
    sha256 cellar: :any_skip_relocation, monterey:       "f92737c631d247477c048ecb74aed8339665e4430d5d36f35090433beaa1782b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "471912cfe8458ec17aefef84ffe74f18e0d41c92fcd8c477d971b464f26e2f77"
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