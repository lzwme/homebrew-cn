class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "ce00cedfaec8e83592880d2127c9aff1344ce61b5299c12e5e6ce75dbe879e89"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "759512a3979efc1894e28edf07e5af1b7406389362d6627e45b996322b194961"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6357625fcb0de9c79eb46f316db6d5633807c2bd5cce5864b1c846bbfe2fea9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df235683f5af551d15629f69b706aaecd6f9e2686b95bd1cb4269547489f7612"
    sha256 cellar: :any_skip_relocation, sonoma:        "90b03047fe72a64c7437a9a49b136b6045edbd0b6f9a5f788a9d8654065f3057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e08f9b21f9444e36736a2e4b08bc06720ede4732add84486e34aaf260bfb0cc0"
    sha256 cellar: :any,                 x86_64_linux:  "c86683d5c034338a1f686d87b351eedb23726dc3a19c1cfe78e787c4f2fc706a"
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