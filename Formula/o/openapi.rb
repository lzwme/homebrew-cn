class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "eea2a0caf3b56b424add73a221d4316a3a1747479155fd5fba8865012c1a0bab"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9f59ec7775ad957e708ca1f70b8ebd9ee73c8f5b3fcd41e3f9eb0dedb7bd797"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9f59ec7775ad957e708ca1f70b8ebd9ee73c8f5b3fcd41e3f9eb0dedb7bd797"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9f59ec7775ad957e708ca1f70b8ebd9ee73c8f5b3fcd41e3f9eb0dedb7bd797"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3d79027931bc16bf264a165545f086785a4a3f293c46b84e9fd02d6f5cbffe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44ed736da8d61ae4e748ee1d18f215fb645e8105756656b2d98cc33e214be311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8488060873e559c915e8daca4426d07286e20337dc4d9af84165e5c5a0750ce"
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