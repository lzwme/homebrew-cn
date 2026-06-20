class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.23.2.tar.gz"
  sha256 "1cf2557a1825408ebcc9c51f2a03d45f636a8be585c9792ad4c801e5600984e3"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1bd3862bb7186968487b0830cd8d4cc2f6e5c9e5f9749ee77d540bc061b9c20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1bd3862bb7186968487b0830cd8d4cc2f6e5c9e5f9749ee77d540bc061b9c20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1bd3862bb7186968487b0830cd8d4cc2f6e5c9e5f9749ee77d540bc061b9c20"
    sha256 cellar: :any_skip_relocation, sonoma:        "79bda633edf8f003963e34c29c6f417172e8e40767d193ea0c62a170459db93e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "194967a3c7d459788d9bc3a7bcbb266352a04188b47f16e7fb553a7d3990f32b"
    sha256 cellar: :any,                 x86_64_linux:  "d67cef4d57dfe96b3f152a85b7b6cfc06ee02599652a555b18ab062e21209949"
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