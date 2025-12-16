class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.12.8.tar.gz"
  sha256 "ec1bb9aa0de4387aa8c8ac45a77a137957d9f33e5000c09cb9c1101302109991"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c832ebca27c844f386c70ad84714f393a96efafbabd19b5f0cb6f7813c126dbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c832ebca27c844f386c70ad84714f393a96efafbabd19b5f0cb6f7813c126dbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c832ebca27c844f386c70ad84714f393a96efafbabd19b5f0cb6f7813c126dbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "479b572fd2e4e87b165190bacbb048339fea41b4a2fec9ff132cc3546a10793a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03ec965b6293f8b945254fdb2cb6c6644f14b75af8553e44fc17f3db4da47d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c68c4862e91f5d4f83dd6c29b13a3e96c957eb389913c81dd6f229a24c4445e9"
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