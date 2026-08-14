class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "a0d4d7a02ce5a5f0992305d7d20dc501eb1804e9ababd9d57f8b2fdb7ad7ddd7"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bafef92e2230fd57dc7b9cf5c43263abaca0d072927f4f05fd0f131c3b0b16e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a206e05916be606c2d8901030dd3cf1d3cfb51861d56b90a808c3452ce4cb064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a096d314a13a89d5f71b268f8a721d51c0a1a0639328a600bdc4765017a4b3ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "a64c2d815c3463492de436f16d8714daf6cb8d2353a6ea10b452500b5c9110d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97815ebc5019b0f5ab78667ca0867b7c121a57b2e6b61b123bbd39e93d748393"
    sha256 cellar: :any,                 x86_64_linux:  "072da87c27c2cf20653d10d2257b85674544d4ddd1a59c41245d3439cfa6ca31"
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