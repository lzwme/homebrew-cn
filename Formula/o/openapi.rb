class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "2bae92b51c9937c460d77de636505d2ddef4a98b3378639f0bcfacf58f012cb4"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f41c214e9731fe4b824940dd34099a0a51fd4f14d9db71237b36bbd655a5e67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f41c214e9731fe4b824940dd34099a0a51fd4f14d9db71237b36bbd655a5e67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f41c214e9731fe4b824940dd34099a0a51fd4f14d9db71237b36bbd655a5e67"
    sha256 cellar: :any_skip_relocation, sonoma:        "e53d3d0208d9ac7ed66b797630546c5bd004717c7d2975a86abbcea654c5c755"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6d9e08f5b068a42ec6db75f598ed1f883c718f31e6e0c1dcdd06ceabce7044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc33126467820e3441f5de0cc881a00069143597b9c11fb19d932685608ab071"
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