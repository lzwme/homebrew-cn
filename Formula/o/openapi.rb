class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "4dd99dfb3aa68bf64cfd65c013415a9cc583cee5e7b8c5642c7ce4d5340f0df0"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a0fbb60f927f7630c7d0ac51b518623ec8a332e53840a02cda3716ad3ea10e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a0fbb60f927f7630c7d0ac51b518623ec8a332e53840a02cda3716ad3ea10e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a0fbb60f927f7630c7d0ac51b518623ec8a332e53840a02cda3716ad3ea10e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b33ddb951b8e88a6987fc0f3f1cfbb741a0bc4efd18d05744f9c6ad9d4417f48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "254ffe38d500259146c22a47844eaaa0df7a589cc18cef38ebcde1ce5ba0709e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6937d740b4ca3e76d78508e820419872ebe7bd09c1cc5996b7d7e9911055afe2"
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