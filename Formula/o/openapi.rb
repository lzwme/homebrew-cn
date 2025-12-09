class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "1b86cf2262118bfcfd7d3f84857fcabdb3f4594044bae1d8cbd12ef5aff5e894"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffc5c73679a677eea97420f70e8f3bc39cfba2e903467a198f475fe275c0b859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffc5c73679a677eea97420f70e8f3bc39cfba2e903467a198f475fe275c0b859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffc5c73679a677eea97420f70e8f3bc39cfba2e903467a198f475fe275c0b859"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b99514936c4aa479e984e5ab178a4b3eca4317fc2856c990f64037a19537433"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "647bae1a685537813b8479129ba05b1996bd442e7ac2ab0a9678cf5f900be675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46bc4e1f81567fd99c6254ee4a35072c8e44641371a28c2c708c127b5a0e25b"
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