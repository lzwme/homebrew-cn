class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.11.0",
      revision: "ea15d31f496ce9e7c13bb76c562a738748bfac47"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ffd371c58949617721de9faac2c8a8c82ff4dae5cf8f08bb8d8b834546cefc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84f34d2be49ba8062595e8d7b7ce48234225106ddc203952a1b7f73cae2eec1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebbd57bd03acc42857832b33feb42bd98b9c73213700bef52c73cb988480250b"
    sha256 cellar: :any_skip_relocation, ventura:        "db7c7f9df75303329da4282568c3e2937077ec6e94104828e16b12fb5db12748"
    sha256 cellar: :any_skip_relocation, monterey:       "b25d90c5a7303634f220ea17d223455ad14757a60ee93b6b706bee3d1290559d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fe7a0486886104f65036214014756fddaecd016ec2503af49790db32061b0d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d45605278277e7adc0647c323e42b41e35573b99b7ba9aea2d205f920419d41e"
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