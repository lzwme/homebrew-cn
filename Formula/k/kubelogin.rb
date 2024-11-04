class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https:github.comint128kubelogin"
  url "https:github.comint128kubeloginarchiverefstagsv1.31.0.tar.gz"
  sha256 "75dd8f9669804a42c65fb52f54b0deb176c4f4d126af0259279fe41cd4d15d6e"
  license "Apache-2.0"
  head "https:github.comint128kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd54f1305a5b4156df1cf66d02285e6729711b13ca7beae544a83eae9c13902c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd54f1305a5b4156df1cf66d02285e6729711b13ca7beae544a83eae9c13902c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd54f1305a5b4156df1cf66d02285e6729711b13ca7beae544a83eae9c13902c"
    sha256 cellar: :any_skip_relocation, sonoma:        "008f52544faf3b23c5c43a4a28ccaaf4c5966e40f8f224f72c7c2dec4555357d"
    sha256 cellar: :any_skip_relocation, ventura:       "008f52544faf3b23c5c43a4a28ccaaf4c5966e40f8f224f72c7c2dec4555357d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd9ec1ade640da4e4da728b42cf40c0eb710d085bb2d3974066b9f1a376f8b1"
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