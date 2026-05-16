class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "42b14deadf8ba1ff17935957a316bf49949baeafadcdad22f2276bf66931e5a2"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d71c23e7dfff368a504cdbde85778053f2c138212876cbf7c138ec27f4d6a6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94a776fbab56ac7c9f993ba26633748c2787ef7063a9c8e8a8d1dfa8efc1f963"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27df4a86e283dddc5e7722f595e50ba859650ddcf51c2f2d2413ebd24406dbb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0bcee7b69e0cd8855fc17fdc95b9e96838101ae1c3f48b52f57b4a9e1913992"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dfdc1f9d683f63e1a13d7a27dec47cf8504598c53a1353b0c0e9cbab99efbe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b05cd1e726f2a6c2d686c84f90a1628d84f2a6ae276c0b495e2cd9c5f00a99f"
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