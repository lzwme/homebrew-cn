class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.19.5.tar.gz"
  sha256 "8769d6ff7b65e7c9a5ea9d5dc70b8882d68ee71fae74ec807af3ee0fa8500ecd"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e0626bb3e95de69345f4ebacbba0b2219cf367c690c1c5a6a6bd83fd2c4dc24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e0626bb3e95de69345f4ebacbba0b2219cf367c690c1c5a6a6bd83fd2c4dc24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e0626bb3e95de69345f4ebacbba0b2219cf367c690c1c5a6a6bd83fd2c4dc24"
    sha256 cellar: :any_skip_relocation, sonoma:        "05e52aa25ad994790eb61865cc99c9e894570daec071abafc663e61fef95947b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e2b5eb7eaca5a48133cd7ce80dbb46c802125c5ce61a1d39dc8d6162b4de81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9a537bc736b615b53428118b2cc9940909605d57f7592b1b51c89ae0227a9f9"
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