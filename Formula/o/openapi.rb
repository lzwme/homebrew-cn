class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.25.6.tar.gz"
  sha256 "257869b9c8115434c068735f5d8281e28a7b1c97653aaabb94e44be140817482"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "118b4b3628ab76dc55ddb50eb24d56d0bd403ca938b18abec1d14463283d72bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "118b4b3628ab76dc55ddb50eb24d56d0bd403ca938b18abec1d14463283d72bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "118b4b3628ab76dc55ddb50eb24d56d0bd403ca938b18abec1d14463283d72bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a27d0912a437fa86ddcd07dc3894b8e054c06e2bfd9659faacc2475a75fdb81"
    sha256 cellar: :any,                 x86_64_linux:      "fdac3284a7385c1902da1094e5e1bfe67e6668d68e3f5d313dfb1c4de1a27b8b"
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