class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "600e7be82f665bd0c7acfdfd9a2db376504d6f87d92849fd69b4092e1197f113"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf03f86feb6e1a1fe52e334e745cabcd5054f0dba58b868996ce041dcdf7ab39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf03f86feb6e1a1fe52e334e745cabcd5054f0dba58b868996ce041dcdf7ab39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf03f86feb6e1a1fe52e334e745cabcd5054f0dba58b868996ce041dcdf7ab39"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbcf7241378082d412fcc276bf451177af61e2c0cb33d3801cabbdeb6a983994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac1d903b0622b864520375f12c684656c3eb6c3b5e1315edb0092d7b16e185f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53723341cff3a3f86049479e5585369f1180b8bd712aba7a3acdd5c8bbec768f"
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