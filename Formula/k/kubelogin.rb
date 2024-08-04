class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https:github.comint128kubelogin"
  url "https:github.comint128kubeloginarchiverefstagsv1.28.2.tar.gz"
  sha256 "f817abe015edd34b1087d1f45978e000d538e13bab90e365ad7db719cc3e30c5"
  license "Apache-2.0"
  head "https:github.comint128kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b438c4454e9b0487698cf6b9d04f176e8a5977e9df3a588781c945b734d8fb56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16b1a88671c076956ce2040bd3d17251f1861d8c0833d3d0c108ac892b8ed459"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4769fc5efb0c4f6fe761de44403a4f4398ed12ad423ec06337cd0ea7524ec03"
    sha256 cellar: :any_skip_relocation, sonoma:         "07bf5cf14568351a12594318657aeae7f6fb44a872a4a0f50f6a6db68a931732"
    sha256 cellar: :any_skip_relocation, ventura:        "c4ced7e103b30466e275153de4604f4d572a3406c7e9ca73080e69794efddf35"
    sha256 cellar: :any_skip_relocation, monterey:       "6f0bc8175794671f5f9bf43353cd0131b9b42df2a19fb4c41e27b88e7934fc7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff07cb7d25b09248b7866d1ef622f952eb05355e6110af62289eb8c2ceb869b7"
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