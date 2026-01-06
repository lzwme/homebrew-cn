class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "bbf8e22f94a4d28117f34f2bc92761c9c36016c23b47dee744e71d61a6e9eb6e"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629501ce500d00c54f594cb28aab2cdea545d7fefbf5bbd984b3246b4c762175"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "629501ce500d00c54f594cb28aab2cdea545d7fefbf5bbd984b3246b4c762175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "629501ce500d00c54f594cb28aab2cdea545d7fefbf5bbd984b3246b4c762175"
    sha256 cellar: :any_skip_relocation, sonoma:        "97f71b00e8eb7072514dfd9747c3d93aed589bc6685c84629dabb49520539433"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "572ae01642283defedadf02d6ed1796d52d993604c9c9fcb7206ce155009f690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "952cfc197859a2e0c46c6ae0394a7456ffe4e8f59fb3e8291596223d5a127a39"
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