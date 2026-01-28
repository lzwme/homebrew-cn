class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "58163d629da853a79055234f395850149bcb779389104526d40ac400c2318929"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e847f2f0cae94088a37f6dcfc0d490f2dea13df027508fcdcbdb746f6baade2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd59d35fe9580d181c63b587cec89b85cb72fd7d28a232d7022395d0d3946223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee455a27c6fb17e792a10df2ecf0bc2928e381542b97a8b1f17de0fa31f772f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6738abf97848ee8fb4232621d00f81e4836e3b5fb8a3e7cfd28e4527ca071e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2982fbffd775f33e0dd136af63d5eac4a139dd1e53df6c6ed06ec23ea159d954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65c5dadce663da106a4755f0f1f683121ca607508bd95a5764a3ce1fdc519057"
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
    output = shell_output("#{bin}/gog drive ls 2>&1", 1)
    assert_match "OAuth client credentials missing", output
  end
end