class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.25.5.tar.gz"
  sha256 "9990f7d8ec48f1479815153c45abf73e77491a635025d2f9add1a9bc75ff0c2c"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8008b78c02e2de14e8b95a7aa4a85b38319d32c93de958ed257694131d8b13a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8008b78c02e2de14e8b95a7aa4a85b38319d32c93de958ed257694131d8b13a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8008b78c02e2de14e8b95a7aa4a85b38319d32c93de958ed257694131d8b13a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97ab77354b28234d570893ea297fe1240ee821ce6229e624aaee26c97bca3d47"
    sha256 cellar: :any,                 x86_64_linux:      "26e2aa9c5a2097bd3143e7010b7288551885fa1571560acd42139234c1557567"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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