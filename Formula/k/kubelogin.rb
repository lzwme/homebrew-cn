class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https:github.comint128kubelogin"
  url "https:github.comint128kubeloginarchiverefstagsv1.32.1.tar.gz"
  sha256 "96bad4ca3fd46851e20fab7514f29c69f32151b08fffe23f47bd7f8ca3a87774"
  license "Apache-2.0"
  head "https:github.comint128kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aac3298b14a60e6e9b9ac8641fabcfac63a9ca86aa98c141ab8b20880499089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aac3298b14a60e6e9b9ac8641fabcfac63a9ca86aa98c141ab8b20880499089"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aac3298b14a60e6e9b9ac8641fabcfac63a9ca86aa98c141ab8b20880499089"
    sha256 cellar: :any_skip_relocation, sonoma:        "e330dec75842d515a68f378084ea42c74883ec45ad0665a2dfe83f8b4d818475"
    sha256 cellar: :any_skip_relocation, ventura:       "e330dec75842d515a68f378084ea42c74883ec45ad0665a2dfe83f8b4d818475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62db3498e0c30a82a157949998af0312920e1b9457a164c3a5618b895c5993d1"
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