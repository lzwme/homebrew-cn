class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "68d9fcadc1f346650cf1df2fbe8b943fd9d17a1564ae6c921290d307cac45741"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "845acf35a7c64dfca7ba0bcc6d430dce9431ef4b4e556d548eedaf3fb9ee6c62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "845acf35a7c64dfca7ba0bcc6d430dce9431ef4b4e556d548eedaf3fb9ee6c62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "845acf35a7c64dfca7ba0bcc6d430dce9431ef4b4e556d548eedaf3fb9ee6c62"
    sha256 cellar: :any_skip_relocation, sonoma:        "35397cce1db53f41c673d5563624d5bd872c2a385b3da6ae23a2e82cbbb60045"
    sha256 cellar: :any_skip_relocation, ventura:       "35397cce1db53f41c673d5563624d5bd872c2a385b3da6ae23a2e82cbbb60045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce9e45d9bce40247151c52bebfb18063f1ba6b655d6e2e05cb025eadf901284d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end