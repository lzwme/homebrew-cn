class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "378bfe94de64d6efb83a1f126450bb075d8451e900a54a513e5e7d0b2df0491c"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8591629557d6f2b353c9ea12f3ca8a0f88a3ad1cfa32422870c58274ef8abcc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8591629557d6f2b353c9ea12f3ca8a0f88a3ad1cfa32422870c58274ef8abcc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8591629557d6f2b353c9ea12f3ca8a0f88a3ad1cfa32422870c58274ef8abcc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dc040f148fe6eb69dfb6a4049a4eac02544928e3f9eff13a8c5ead0284c0e4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2d56e98f32fce1040474d5bd10b98d380b95d75dee9b3995b4d2da62084f4c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca070f8334f66f597ac27f6b7665fe2ac25ba33409506f870ebfebede4bf88f4"
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