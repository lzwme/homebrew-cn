class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https:github.comint128kubelogin"
  url "https:github.comint128kubeloginarchiverefstagsv1.30.0.tar.gz"
  sha256 "4f17cbc7f9bc25f493cc4b7eeb05d1be1f908735186a763c78c77bd6b3931d5b"
  license "Apache-2.0"
  head "https:github.comint128kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baaebfe34d1c093d17fcc7bdce8aba5dbaafc46a6329e239f92ce9bfb8fe4a8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baaebfe34d1c093d17fcc7bdce8aba5dbaafc46a6329e239f92ce9bfb8fe4a8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baaebfe34d1c093d17fcc7bdce8aba5dbaafc46a6329e239f92ce9bfb8fe4a8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "02137d9600043aa450cfc08f6af3d87148cc78cf12b1e4d21b8d62faf8f76ce0"
    sha256 cellar: :any_skip_relocation, ventura:       "02137d9600043aa450cfc08f6af3d87148cc78cf12b1e4d21b8d62faf8f76ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "860459b6a19c08d26e060e4d047bc6e86f2588ea936f06fc5123818e43f3d6ec"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-oidc_login")
  end

  test do
    version_output = shell_output("#{bin}kubectl-oidc_login --version")
    assert_match version.to_s, version_output

    assert_equal shell_output("kubectl oidc-login --version"), version_output

    # Connect to non-existant OIDC endpoint
    get_token_output = shell_output("kubectl oidc-login get-token " \
                                    "--oidc-issuer-url=https:fake.domain.invalid " \
                                    "--oidc-client-id=test-invalid" \
                                    "--skip-open-browser 2>&1 || :")
    assert_match "fake.domain.invalid.well-knownopenid-configuration", get_token_output
    assert_match "no such host", get_token_output

    # Connect to real test OIDC endpoint, with invalid client-id
    # This is a public test server: https:openidconnect.net
    get_token_output = shell_output("kubectl oidc-login get-token " \
                                    "--oidc-issuer-url=https:samples.auth0.com " \
                                    "--oidc-client-id=test-invalid " \
                                    "--skip-open-browser --authentication-timeout-sec 1 2>&1 || :")
    assert_match "Please visit the following URL in your browser: http:localhost", get_token_output
    assert_match "authorization error: context deadline exceeded", get_token_output
  end
end