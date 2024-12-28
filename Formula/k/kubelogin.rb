class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https:github.comint128kubelogin"
  url "https:github.comint128kubeloginarchiverefstagsv1.31.0.tar.gz"
  sha256 "75dd8f9669804a42c65fb52f54b0deb176c4f4d126af0259279fe41cd4d15d6e"
  license "Apache-2.0"
  head "https:github.comint128kubelogin.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3867cd6666184a96fbc06c8f87fe7f07abb090dabf2d44020b900c4a61968f61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3867cd6666184a96fbc06c8f87fe7f07abb090dabf2d44020b900c4a61968f61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3867cd6666184a96fbc06c8f87fe7f07abb090dabf2d44020b900c4a61968f61"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb5c82e92ef9b6f1b3a9968ec1f2da4775beb2418ddac7e784d7577c4c1f65a5"
    sha256 cellar: :any_skip_relocation, ventura:       "cb5c82e92ef9b6f1b3a9968ec1f2da4775beb2418ddac7e784d7577c4c1f65a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "678d8e163fd99f67d8edfa04e53fff7158f02f2de03ffcec748a487ed78d65b2"
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