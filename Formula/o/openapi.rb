class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "7c5831e1201d8144b148561c6ed88ce73cee053392d9ace6645c923e898a1aa0"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1451972ed39ff239958e078e53a9e020551c5034b068dfdd4fa68448f3857674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1451972ed39ff239958e078e53a9e020551c5034b068dfdd4fa68448f3857674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1451972ed39ff239958e078e53a9e020551c5034b068dfdd4fa68448f3857674"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba089bda25a2b41ee444acedd76b7be2939314cf03da595983ac31b6b2354fa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a12b2ed01035c0a12320fe93843c62056f8eef2e6db04a44fba572d4abd00d68"
    sha256 cellar: :any,                 x86_64_linux:  "22908f32b6f1f4d6fd08889b83efc6e0f6c433dc7c5a3bb03bb4f2a5753863ad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end