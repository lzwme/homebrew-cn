class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "2d1cb22b79b515ba0faefdb721b2d199f8094d76badb671ead88bd1454e76e10"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abde836a07dc5738b01357bbbacd940ebe2d44c865847de49cbd79926e4ffdb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abde836a07dc5738b01357bbbacd940ebe2d44c865847de49cbd79926e4ffdb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abde836a07dc5738b01357bbbacd940ebe2d44c865847de49cbd79926e4ffdb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4a892baf5ce8d9dd057fa4ec3aef81e50053a3b3da0c2df912fbd1ca0f80d04"
    sha256 cellar: :any_skip_relocation, ventura:       "d4a892baf5ce8d9dd057fa4ec3aef81e50053a3b3da0c2df912fbd1ca0f80d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "982630ddd89b591763d41cd0f31c2cede134f78f46aab1be6f111e01600aad9a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{stable.specs[:revision]}
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