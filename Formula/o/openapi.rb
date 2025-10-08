class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "8baed9c5e50f6939e1ff7d1f9de936320412c3a29f2ba7d460474e9e0f9c55cb"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a978af5cf4b4849a2daa61598c8d181b82281c387d40e0e635285b9cdcc60315"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a978af5cf4b4849a2daa61598c8d181b82281c387d40e0e635285b9cdcc60315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a978af5cf4b4849a2daa61598c8d181b82281c387d40e0e635285b9cdcc60315"
    sha256 cellar: :any_skip_relocation, sonoma:        "f24cc8496cc340b1fc224f4da11756617dbcc6a9f70a86fd0f493f3abf02ce6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aa288b9666503d07c4c3b9c1af62fbf04ddf01bf6b1dac13ea85b7bd270406c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daa4c0b02da538b5599c854be5372f5339192e49d2c7caa69b7eb2a6472857f3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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