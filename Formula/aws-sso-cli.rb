class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.10.0",
      revision: "70010555aaf4be472cecd0dc728e69b01c1d7834"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "639e753cc497c45fc91b5a6f20d8be30ebf129b13337cf52a9a8e6eef6ffcf74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9149b3dac306f4954a7177e9aa4bf697ad3fcc3523547623450fe9ed9fd8ad1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "519770a8e2b6c4f66cf86cef89b6094fa487d5fce27e7477c2bbec60eee92f3d"
    sha256 cellar: :any_skip_relocation, ventura:        "7cb75b80f36b4e2e50ed0bde00eae5881bd3601c662609b335919bf5fdf01a35"
    sha256 cellar: :any_skip_relocation, monterey:       "3c389d1b64eb5c00f03cd81a740f3acc4bf27a1db5972c6b7395f7573cb44e07"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b13ef9b27b07494ebd116790df7feff1629371ce58d05a6526131ebe5f88dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3491c9b02560aa0ae07a5de4a8166395fb0fa31b2fd1731884fbc6a536ff1c15"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    system "make", "install", "INSTALL_PREFIX=#{prefix}"
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "No AWS SSO providers have been configured.",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end