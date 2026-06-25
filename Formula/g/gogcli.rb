class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "911cb1dc02f80b0b3a4cfdc536755eefca487c21e5eed9f25c644a4d71d243c6"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e3bae24566e7e7dd65cc038000719dec0ab0ecc81390a4bc83b6f6b86d43faa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d8a57506d61efdf514003b79a51c3abd17f955b2d79c11d89ce17d444e984fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83eebac686644116360540d2547cdf1c996efd6725816987f842d1ac7a6bb15a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c949fe3d66e394ae189e5fe517ad762fdbf5b61abe5a7d4e0054bc3f5c20ad38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6c89a34a627e898d5c3c4e734dceef74b712d68ecc615f2d72ef9ba3c5201f1"
    sha256 cellar: :any,                 x86_64_linux:  "c5d4204eb21d147d11db3b9aab8eac1b651fe621a4414be8cb9183723fede0d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end