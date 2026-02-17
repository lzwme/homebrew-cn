class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "c658124cc40a61d0b50b821e6a3ed38b0f99f4fd987a84a1631aa77258b4a0e2"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b661c086b4a5cff0f4eedcc4f92c9f166c0803285be2df105604d62ec06d1000"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b661c086b4a5cff0f4eedcc4f92c9f166c0803285be2df105604d62ec06d1000"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b661c086b4a5cff0f4eedcc4f92c9f166c0803285be2df105604d62ec06d1000"
    sha256 cellar: :any_skip_relocation, sonoma:        "fff3344368932310fa0a739fbc84736e6b77c8307d411ef4aaef8411e7c5701a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d879afcff0d7ffdc6a37dadf89d6fee29edc84015c3f94c0c3a54485cc3ec442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "892f8d30078637a4a4f39967bb19ca314bd78c738c6ea933231a39e2c1c9351a"
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