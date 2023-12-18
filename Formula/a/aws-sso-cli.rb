class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https:github.comsynfinaticaws-sso-cli"
  url "https:github.comsynfinaticaws-sso-cli.git",
      tag:      "v1.14.2",
      revision: "792f11ec86a5ce6683ba2df7cb544e4f76f2431b"
  license "GPL-3.0-only"
  head "https:github.comsynfinaticaws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e69f77627e5b12baa6101e793e4f9f559e4be21ef28b3f5c7b24ce41002bae75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf5f2e754bbdfcd061e11737c65e8d897f0f02a322d38f97e4cca7003fe1d473"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6b448badc7377a56242e6a82eb60a9ebfbee12af454b94fd4c4e97c1e4720aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "18a92bd37a658872ec9484815c4012f132faed6e8efc3f090f149c90066cccc9"
    sha256 cellar: :any_skip_relocation, ventura:        "6003663f2dbefd3ee3857439daeab30fd339d99083f3a1e6e9c4a0cb4bf17180"
    sha256 cellar: :any_skip_relocation, monterey:       "66c03d127fac93fbbc48a769487d9029e943c7fdcf06d111e7749a9805e495ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea3342a9c0771484ad689d3f2987d9847be45b94ced04e39578a8cc5448bff29"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    system "make", "install", "INSTALL_PREFIX=#{prefix}"
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}aws-sso version")
    assert_match "No AWS SSO providers have been configured.",
        shell_output("#{bin}aws-sso --config devnull 2>&1", 1)
  end
end