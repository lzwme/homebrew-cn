class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "114bc52eb1087ff99bba8a6900d35c24543b9feecf5db42798df3813f9de51af"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91837ee2e43c8a13dda8b9fc480caa4bbea8fac0db6901297af7702428573939"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91837ee2e43c8a13dda8b9fc480caa4bbea8fac0db6901297af7702428573939"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91837ee2e43c8a13dda8b9fc480caa4bbea8fac0db6901297af7702428573939"
    sha256 cellar: :any_skip_relocation, sonoma:        "03a38268210808559e6a6438b270ac6cc3bee37ab768e269b5d303e71c526eb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42b5434052f4f1eb8f114e6b716f3422da443cca1cc888e944fbecf5edd0f1a0"
    sha256 cellar: :any,                 x86_64_linux:  "3a968c2b66351619c4a7bb7f294b9a1582fddce41ac165bd4bcd8625d84e420e"
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