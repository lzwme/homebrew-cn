class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "464838b027a189bf0064fb8db57d6f22f9386e6c7171801083f7f8a537c98254"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aa67932ee254aa0e09197f9ca6c26b7db417d3ef9591c9fe959ebca7fd60251"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aa67932ee254aa0e09197f9ca6c26b7db417d3ef9591c9fe959ebca7fd60251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aa67932ee254aa0e09197f9ca6c26b7db417d3ef9591c9fe959ebca7fd60251"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e681790518fc8aa97c4d7ea3bf2798db042081f2418cdb9a432955eac41085e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc26ea4403e0915584844279b1e35084a885d2a1d283f0669bb2c3b367e4d23c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3321035bcbd39faacfd626f0c18c4837e940dd44c4d9f346cd237228eef06823"
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