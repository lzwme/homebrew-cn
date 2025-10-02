class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "3c0869580484250d358b4f978864642c6a992b37ce8ec212505739c808ab72b2"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d37c2bf60a15da4f5f4419c812df7fccb6589a8283721108ac79841bd22f860"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d37c2bf60a15da4f5f4419c812df7fccb6589a8283721108ac79841bd22f860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d37c2bf60a15da4f5f4419c812df7fccb6589a8283721108ac79841bd22f860"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd6ef5a5ce8c56b74c64327bd201ea0d970148acecb0409d08e2f7f319070c1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10dcd5f1df7d476c7a494e52a224b7a84d1f5315336ff6c3797ebe3b301c1dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9f340c85ae63b680bb3fd393ad187056ecff3a23b83d1e83be2951c3660e3f5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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