class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "d6655ab1979e87e61d0c14f7e1a8608327922c28a518c5725ff1b83b56c07210"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73caf015378bd5a0c58bbfc077097e9f08931aad8f7264e28319e56e641bd9d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73caf015378bd5a0c58bbfc077097e9f08931aad8f7264e28319e56e641bd9d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73caf015378bd5a0c58bbfc077097e9f08931aad8f7264e28319e56e641bd9d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a48ca54f19cec817f76e21b5ee064dfce2fb349ebf6e7cf6ee8c7e4c9dfbd2b"
    sha256 cellar: :any_skip_relocation, ventura:       "6a48ca54f19cec817f76e21b5ee064dfce2fb349ebf6e7cf6ee8c7e4c9dfbd2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ccf24389c86c980278497d0d63bb05665ae74881102d8dce412422c25416dc8"
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