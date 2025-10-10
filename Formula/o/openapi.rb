class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.7.11.tar.gz"
  sha256 "2148e52d708b099995b83892fda2e01e23b29f6ef358afa27fbbe66b7c4c6833"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e49ed070f13b3a313e84c8b1900ae736d030386b57305c3968898734f5e32fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e49ed070f13b3a313e84c8b1900ae736d030386b57305c3968898734f5e32fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e49ed070f13b3a313e84c8b1900ae736d030386b57305c3968898734f5e32fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "0490720bf2b8048d1106c8890c914f815b075db05349e1b447f3ea95861121ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eeeb3d86f45a7e5603a62f77487331a75c0feef125abbc1e8dbb8b9b05244b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6df5703c74c2b8401557749dfe52e4f9c276c3007412bcc9a0adfb097a6652c"
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