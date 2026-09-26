class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.25.3.tar.gz"
  sha256 "547295781fe3ca2cd68b29690da2291b4afa406e12917cf2163e21d49471df53"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b330e8a39a3edda5abc3869bf1f9954de72813f3db3a6013011a37ddff45b4ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b330e8a39a3edda5abc3869bf1f9954de72813f3db3a6013011a37ddff45b4ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b330e8a39a3edda5abc3869bf1f9954de72813f3db3a6013011a37ddff45b4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bc52b206d4866a29ec169845c21bb8eb7e458a3a624cd14e72ccd4a9dfc3eea7"
    sha256 cellar: :any,                 x86_64_linux:      "ba1cd83c1e1fa25ec89d23870bc43301c9e8641fe9d0c60c814b1e29d0f192b5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end