class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://ghfast.top/https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "1b213e68ab138cb71930bc886cb90847b165e04036909087bcb17d6958278d74"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b8a5272f7fdc9eb223005c072dcbc65165dc2894b9bdeee501f4e1d30e20630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b8a5272f7fdc9eb223005c072dcbc65165dc2894b9bdeee501f4e1d30e20630"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b8a5272f7fdc9eb223005c072dcbc65165dc2894b9bdeee501f4e1d30e20630"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb8020e76d81385dec6df2ef225e1f4b5383d4fb50e4389f79d85df7d6d82b18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ac320fd5a8dcab495097b197c4f556971d419e5af9acaa0cb4e256115ca2e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c2824fab0e840dfbf133c644f559288c4d011ef4dc1e76b871ac0968dec904f"
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