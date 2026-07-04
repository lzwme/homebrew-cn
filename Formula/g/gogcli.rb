class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "203d87caf11af5fdc5c78690d80a2e248f2567c6d15c7c337cbedc48536dfebb"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5272dcc429cddfdf95bf75057a4e2b46e8946d91f26a17e546b28f743ff5d89f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "034fac1b91d939cb6bda356f2d1447140e5b60ff563b924c93d1868fe1e120d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5bb847e39e7529865a728174c6d05e5744f069bd7222ff70d6570eaef716941"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9bed52a8b77002ffe041c9e69c8957d29fcf883ea90675074fa813bacc42e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65845951a4477cc20a995e710a5c7e29236529c8aa946992f9b4c5f30f570ef9"
    sha256 cellar: :any,                 x86_64_linux:  "a73c89c61346832b66cae1be0849a38b82453efe6af73cb55eb7c9bfae87bbe3"
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