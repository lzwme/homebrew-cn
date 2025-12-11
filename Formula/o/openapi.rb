class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "b514781724a65c15f5a15aee6b63e2fe231acf08109544ebdd95d68d9ca673be"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c890598ef2ac2b2ae2e37c807d14324a87c75ea6e0559146e32048f1792f55d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c890598ef2ac2b2ae2e37c807d14324a87c75ea6e0559146e32048f1792f55d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c890598ef2ac2b2ae2e37c807d14324a87c75ea6e0559146e32048f1792f55d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "25aae709acef83672313363b570927b013b098da00ce118fdb24ac799fbe9c4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e12969a3e3f06379d083efabd0f99b4e5334c4dc7c723b15f6f3e176077869e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7990a992b4715e4b89398af9d80d03705d664e020ec617f025a81c8e5cd53aad"
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