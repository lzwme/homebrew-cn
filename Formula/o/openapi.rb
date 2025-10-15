class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "e35ed3994102f81ab6c1fc294cad0f231407ca4beed8a1f46d68dff0cc75dfdb"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e47599c407053923c4d6a539a3ded2ade5d656516a7d313bcda769021c5e6618"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e47599c407053923c4d6a539a3ded2ade5d656516a7d313bcda769021c5e6618"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e47599c407053923c4d6a539a3ded2ade5d656516a7d313bcda769021c5e6618"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d09482b69ec752dc60f62fbb70b0237f9c827f54022345799594432b5398f2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67bd66ac7bd342f38ef15a99f4ef521f478adbf8c158087aaf03a5dd51192e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1de58a6a94bd526300796c1ab0dacac750562647fcb6667c8bac5b77ae561a5"
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