class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://ghfast.top/https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "a0f793acdc8b8b036a4ebaf59adc5b02905011140fbf62558bc54f895237174e"
  license "Apache-2.0"
  head "https://github.com/okta/okta-aws-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c9acadfda072afb9d2e0d173303490c66b8c63812435545f6ca7d88e674c376"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c9acadfda072afb9d2e0d173303490c66b8c63812435545f6ca7d88e674c376"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c9acadfda072afb9d2e0d173303490c66b8c63812435545f6ca7d88e674c376"
    sha256 cellar: :any_skip_relocation, sonoma:        "228c00141bad7f17c34d48af13bc5ae7ea3eb66c8dabfdb8f445d8e72dce4b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47f903ae2261e73a38ec5eeba521df123fee221319da46b44e8c5f28b13fe36b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "267811f8015ab1bede61b9c658e3d8eb6b6b49df05b8f901ccc29e4a4169a82b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/okta-aws-cli"
  end

  test do
    output = shell_output("#{bin}/okta-aws-cli list-profiles")
    assert_match "Profiles:", output

    assert_match version.to_s, shell_output("#{bin}/okta-aws-cli --version")
  end
end