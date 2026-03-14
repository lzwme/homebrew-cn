class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "a938110a2c4e63a45e31f0ab106ebda55ee85203373baf195bf6c57a6e2698e6"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40c72e9d6af771e9248534cb59d41520a70568e05a8cbb79f609c7ebb03f6f65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40c72e9d6af771e9248534cb59d41520a70568e05a8cbb79f609c7ebb03f6f65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40c72e9d6af771e9248534cb59d41520a70568e05a8cbb79f609c7ebb03f6f65"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9bac7ecd5734a5eb644749b6c4e03550392986eb72c5d6260632d7b0007ec3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50b637021bcc72b5df584e81db41ac2d0005e101eb4f80c039dcc06f25dc5bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ecf549bc474e6f7b435d60570c5b83ff94917574a02dc569b7cc3c32fde042a"
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

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end