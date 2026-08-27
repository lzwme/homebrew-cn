class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "d803a250e6aac385327e310097b535ce8aa0a979266f5d44580d595383088335"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a32469eedcfea09cbbee0451ac605c3910111707d5477ea85bd9601ecdcb7b4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "609a117d0d418add9ea763ba62218d1c5a1ea2753d5979416381ea3df533501c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2849d43fa822f1f209222048ed96cb529705fa7bccf4c3f29867b39dc93ce2d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "83c46d419ea5a77c77a8f6a2f6e884f738bfc4a9f18334f40b4bdd47307d5b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab14a35d84044ab55a6650380b47ceefdd228b535895af4ee3e03281fb285a87"
    sha256 cellar: :any,                 x86_64_linux:  "371aa8f094ad522e5b4b7db642e7fc03b1c8d38cccb76a11415de9de3e8e1613"
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