class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "45ebff8e4f740a195abfea54594d12d978d15577afe2ea4d0fe80151b988f1f5"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b14520cd48676e2ced0a454b8ca65e91882f775d6806a74a87017560be6bdc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ec36075d1cc7834bd4e7f62236a085de73e72595413c48d006cc190dd960cb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72bcfd7ea697d14cf403bfab4a8af62d0866fbd27055848f9e160714ca934f7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "703740844a58c713dcb7e2e6b2865832fd52fbad6181b2be59530dd8a5fe7951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2d2634ef9a98db7d0bb0626f8006d7367caaa286d6c37f91698122ee62e1444"
    sha256 cellar: :any,                 x86_64_linux:  "a7228db7d78cf13bc336ebb7718a861aaf00aa3ad028848cab4e47bdb20aafd9"
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