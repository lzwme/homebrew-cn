class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "49f6306b47c05f1ed02bad585056cf34cf917e6a1afc32507254909ef3f85b88"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed020cb68df4bcaa05b094b0b8b75ebe564c3230f5ed0bcca9e80fe6e34add36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed020cb68df4bcaa05b094b0b8b75ebe564c3230f5ed0bcca9e80fe6e34add36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed020cb68df4bcaa05b094b0b8b75ebe564c3230f5ed0bcca9e80fe6e34add36"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0b776e5faa8cd8766e265dd3cf2d546712417c7b6be82c26220809a6aadcc0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28640e9e1f2074bd7cd758e6c6b67df27d3dc567b28ff34116034ed8084596d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f03c047f94e5c651ff6743f28cd0670022f9ac1b9be6de9a16f9245ed10730c1"
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