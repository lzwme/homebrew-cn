class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https:github.comcloudentityoauth2c"
  url "https:github.comcloudentityoauth2carchiverefstagsv1.17.0.tar.gz"
  sha256 "5ce0453584c79ebc5679a8613b22da21ace5545aec40da54f93aac2ffcbddc4b"
  license "Apache-2.0"
  head "https:github.comcloudentityoauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0987135ef9d32d07260ecf96a5fa8e1d49dd1b1b73b43d04cb241462f7be9585"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0987135ef9d32d07260ecf96a5fa8e1d49dd1b1b73b43d04cb241462f7be9585"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0987135ef9d32d07260ecf96a5fa8e1d49dd1b1b73b43d04cb241462f7be9585"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f56879d8aad33150f2d723ba48e3ec40676baa8d351695a49f305674ef9b4ca"
    sha256 cellar: :any_skip_relocation, ventura:       "2f56879d8aad33150f2d723ba48e3ec40676baa8d351695a49f305674ef9b4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "094855633d25467fe90cb4e1d89fc13d25e606cffcfa6a3e69fb64f6a2d7c6c4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit= -X main.version=#{version} -X main.date=#{time.iso8601}"

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"oauth2c", "completion")
  end

  test do
    assert_match "\"access_token\":",
      shell_output("#{bin}oauth2c https:oauth2c.us.authz.cloudentity.iooauth2cdemo " \
                   "--client-id cauktionbud6q8ftlqq0 " \
                   "--client-secret HCwQ5uuUWBRHd04ivjX5Kl0Rz8zxMOekeLtqzki0GPc " \
                   "--grant-type client_credentials " \
                   "--auth-method client_secret_basic " \
                   "--scopes introspect_tokens,revoke_tokens")
  end
end