class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "24e9dc7f49fde40e5060bedfd16b5d9c3b7bafa08ec32238f5133c4897926859"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf55307e3672076736a3ed72c4887c3659d34ff49474d082b6fe7e0f4aff0970"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf55307e3672076736a3ed72c4887c3659d34ff49474d082b6fe7e0f4aff0970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf55307e3672076736a3ed72c4887c3659d34ff49474d082b6fe7e0f4aff0970"
    sha256 cellar: :any_skip_relocation, sonoma:        "97899d7e0abd2f1c32c89ae3a9e2cd35b3beac7a44eb243b31dd5185e86f742a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "857915f7c441d3fe0a2d1bbe95453c2427e1ce290f533a2f59508bd783db1836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9b9b31fc4a2f89e25b7555f70d3843e164fe414e6149e2046c60ad154fe17f"
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