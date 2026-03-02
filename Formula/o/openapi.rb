class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.19.4.tar.gz"
  sha256 "dfa96e22d13b38846b962e26855b1ad1642be25db09ad9bc23088df8074b7b66"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0a092855edbd74af8ec94723509b47d09a022571c5e865e26a833de9271ef6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a092855edbd74af8ec94723509b47d09a022571c5e865e26a833de9271ef6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0a092855edbd74af8ec94723509b47d09a022571c5e865e26a833de9271ef6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c246bc46dd4df25eef0ae2a13d996b599d4390beb4dec99fb133439aaa22acfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c285b167cb738bfd195d92cb541a311d625a58fdeaaa8d01eb7bf60cc231df83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80e897053e7feb638b5aff2c4385c041bbeef247128c831ba6d8258957d38f71"
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