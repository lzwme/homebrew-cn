class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://ghfast.top/https://github.com/int128/kubelogin/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "bf73e9d11c3eec408191532d25a25aae37d588f30c256a6fa6ed2029777a0ee4"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "539ea5e6e5e3d4e2f1bb5b644a012ad1fce7e4910eb8f450ba32fbec91d7f238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539ea5e6e5e3d4e2f1bb5b644a012ad1fce7e4910eb8f450ba32fbec91d7f238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "539ea5e6e5e3d4e2f1bb5b644a012ad1fce7e4910eb8f450ba32fbec91d7f238"
    sha256 cellar: :any_skip_relocation, sonoma:        "a14b682ddf83845d8abd4ac7f1e6a38455f4c56459edfb12f81cd88c680b60b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afd1ca34203d3a27de4c337b3fb110d12a38012d62a67b1f702da21726f428d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3c25ddd374b53035a8b5e7e7b6ccf8f40a2852f36e4036bccdbf700fd597092"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-oidc_login")

    generate_completions_from_executable(bin/"kubectl-oidc_login", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubectl-oidc_login --version")
    assert_match version.to_s, version_output

    assert_equal version_output, shell_output("kubectl oidc-login --version")

    # Connect to non-existant OIDC endpoint
    get_token_output = shell_output("kubectl oidc-login get-token " \
                                    "--oidc-issuer-url=https://fake.domain.invalid/ " \
                                    "--oidc-client-id=test-invalid" \
                                    "--skip-open-browser 2>&1 || :")
    assert_match "fake.domain.invalid/.well-known/openid-configuration", get_token_output
    assert_match "no such host", get_token_output

    # Connect to real test OIDC endpoint, with invalid client-id
    # This is a public test server: https://openidconnect.net
    get_token_output = shell_output("kubectl oidc-login get-token " \
                                    "--oidc-issuer-url=https://samples.auth0.com/ " \
                                    "--oidc-client-id=test-invalid " \
                                    "--skip-open-browser --authentication-timeout-sec 1 2>&1 || :")
    assert_match "Please visit the following URL in your browser: http://localhost", get_token_output
    assert_match "authorization error: context deadline exceeded", get_token_output
  end
end