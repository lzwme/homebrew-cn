class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.12.7.tar.gz"
  sha256 "f2349356ad5530f46f698ad792a60505111ba4f611c1ee8615fea10949014166"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06fe53d520e222d0f72fe8302c31f2cd91f877304ea3cd2df9d1a0ce037d0c6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06fe53d520e222d0f72fe8302c31f2cd91f877304ea3cd2df9d1a0ce037d0c6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06fe53d520e222d0f72fe8302c31f2cd91f877304ea3cd2df9d1a0ce037d0c6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6cd74631306f25dfd1c14d73c64c124c1ac68da3505e21126bbfadbc4e3bef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d877fab99e24a8327cf2a69cf449e7b39f56a0fe8fe0b4e381819145c3785a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a4a62b4fcb6c7b003d534d3b6815610abf0757f754d2c273189a1b80c47da7d"
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