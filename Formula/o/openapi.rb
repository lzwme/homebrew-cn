class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "d700e54acd55807b5dde798162485c0ef75d1788e81ebf1582f12b94bd5fdb9a"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "377bdac4dc8f71863743cd26ad7ccad5f8bb5b3cb4d7f1784df3e49fdfd0bf2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "377bdac4dc8f71863743cd26ad7ccad5f8bb5b3cb4d7f1784df3e49fdfd0bf2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377bdac4dc8f71863743cd26ad7ccad5f8bb5b3cb4d7f1784df3e49fdfd0bf2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "32d7bfd0660d7d31ea810c140a81029106131e1bb3cf8b1fad4fe28196c2f884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "254e1f7fab5ff4c0c7e2d8bd79c524540aa41d2bfd2b3bf3ce94a2ac9c16bdfe"
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