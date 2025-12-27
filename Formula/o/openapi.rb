class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.12.8.tar.gz"
  sha256 "ec1bb9aa0de4387aa8c8ac45a77a137957d9f33e5000c09cb9c1101302109991"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e77649a320af0c91fafb65b2c21bde42612f1daf9fc0dcf719eb02dc547d2e60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e77649a320af0c91fafb65b2c21bde42612f1daf9fc0dcf719eb02dc547d2e60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e77649a320af0c91fafb65b2c21bde42612f1daf9fc0dcf719eb02dc547d2e60"
    sha256 cellar: :any_skip_relocation, sonoma:        "4746b56bc54c0a6c590935965dabb912c9edd2a9af3edd235ffb7a9e6c138b4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed89a4b1937839b3480d4005da02569e0929a35bc9b6bc80141c966daba46245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84579bf35f170548a88c482049ecb58e6c3b9d2e0a473b768331f5ee6fc43556"
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