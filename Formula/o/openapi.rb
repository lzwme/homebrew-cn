class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "4116ad05880a8ffc0b5c13b6b4fdc76e49aff02ca91e267fafd6aebc0dca9455"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a771c08602650dff8cca992847d69c909ff7b4ddaf1ec7f7ee3a59d76dfc4978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a771c08602650dff8cca992847d69c909ff7b4ddaf1ec7f7ee3a59d76dfc4978"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a771c08602650dff8cca992847d69c909ff7b4ddaf1ec7f7ee3a59d76dfc4978"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a5a84d9479c2bee6af973a3a6f90b284e8537578de97b99166abf33be68fd7c"
    sha256 cellar: :any_skip_relocation, ventura:       "9a5a84d9479c2bee6af973a3a6f90b284e8537578de97b99166abf33be68fd7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c05e054cdd6c6ed5d177d36e0f61d6f8c89247beee9a3887090d109398cf65"
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