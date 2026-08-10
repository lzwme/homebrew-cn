class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "d43e9333b93dfbc6673ff6d1349f49b2b947877403ac4d9dd6a1bcaaa2a6a780"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b1f44ffd1d2aec152efc25be1112147ba58acd73fe7fdf73a7dfa9d9df07644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2032cba094feabb3f51f463314f549df9d3ac8bf6a16904c54d173dd1ae7cf27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03725d9b167e03d2a37e630a07d7cc64ab436c38103909a1eb6cd7bddd2b17e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "009b660dafa130a602782fc07e664f291b5cb3360da68bccc97d2b917d2dc366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db1d98e73677d3a098d6e6abf2d42e3ad2efc59436ff48cc1a429d650732d3c2"
    sha256 cellar: :any,                 x86_64_linux:  "0f0b18d8bcabfdf31c81ab2f1ef79cccf6219ed28eb7c962e82f4ff946049742"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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