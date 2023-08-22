class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.13.0",
      revision: "3e719f3572a8ad4a7455e328d39ee704d9bfcc06"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d4bab7477ce4f34f618e63856a1547ebef8340dc69493aaf3785584cd66f21d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a98196d26dff50cc09c3cec041a26279a3fc75db8f2e572dc43b92d873b84352"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9215e7243971c9b6be519cef6726784833b6d919979643a8a5bc0ad8c755daa"
    sha256 cellar: :any_skip_relocation, ventura:        "3a55e7c7fbb1c694b378a1839ea6161fbf124349e6a79ebf641fe611976583ce"
    sha256 cellar: :any_skip_relocation, monterey:       "a81dca6976eceb825931bc8ba46564a01b50cd314cb7e503599aee6c7ab4149f"
    sha256 cellar: :any_skip_relocation, big_sur:        "43569b9708ce2f3a591782def2e087940d4809b3c228855e3372f1a9726b8495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6489d5b09f6c5b0b674ad9ab44f6771a2cafd39ab2893be96ce8f644340343f"
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