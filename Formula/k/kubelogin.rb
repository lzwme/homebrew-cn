class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https:github.comint128kubelogin"
  url "https:github.comint128kubeloginarchiverefstagsv1.31.1.tar.gz"
  sha256 "80224a49a2133bfef96d54b277065d4823faeb411fa1fd22f28009d31dcd8355"
  license "Apache-2.0"
  head "https:github.comint128kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e8bbacf41e7ae77170391e882c29601aba3f90099615ed91b4ab0e58ebf3d99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e8bbacf41e7ae77170391e882c29601aba3f90099615ed91b4ab0e58ebf3d99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e8bbacf41e7ae77170391e882c29601aba3f90099615ed91b4ab0e58ebf3d99"
    sha256 cellar: :any_skip_relocation, sonoma:        "1921051de1894d2358a60b7ffb7b44ea5c618f7e20a7996b6e53554d57c9b5f9"
    sha256 cellar: :any_skip_relocation, ventura:       "1921051de1894d2358a60b7ffb7b44ea5c618f7e20a7996b6e53554d57c9b5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "938becd0829f2e0990943a2c05e9f458856456dc190597c2f6020aa06c4defef"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-oidc_login")

    generate_completions_from_executable(bin"kubectl-oidc_login", "completion")
  end

  test do
    version_output = shell_output("#{bin}kubectl-oidc_login --version")
    assert_match version.to_s, version_output

    assert_equal version_output, shell_output("kubectl oidc-login --version")

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