class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.7.12.tar.gz"
  sha256 "21caa9aa7611bee6b2a645b86523e1562bcd0e6b5bb1146ac55ccbe45a29cdae"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a130aeedede99bff1b7942b67d4eb487cbfced54ec16cc96eca1c26adc64b3d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a130aeedede99bff1b7942b67d4eb487cbfced54ec16cc96eca1c26adc64b3d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a130aeedede99bff1b7942b67d4eb487cbfced54ec16cc96eca1c26adc64b3d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbb8eb685cf727676af98ea80db9fc9941df90b991aefe49164541c14e90c66b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cea0d534492f723c0697baad42bbcd68e9f235a58ac56555b9f0f59830f2ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65d26e09be758dbba71df08315113db16688c04b6ada22dc2ba4b90e4958d1ec"
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