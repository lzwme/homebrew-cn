class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "13cc07fe249f9ca2affe9320a96ef8fdee98b64f15a14bc1792ceec59d37774b"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18f6283407b3693fee845415f41b942c819a75c774fd443145b1706c24cd7ad8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d34d97c66f5b64e9119e96d0b45b8576f0dcb585d93827757f2eebaf2b842bc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c095c1cb3a9a36d9dff1f9b8374295d246ddb86cd82f66a4e12db6c15290757"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3bcc24969e052eeff11d1903061d7b3fd47f52cea1c41d56cab82950d3ed53e1"
    sha256 cellar: :any,                 x86_64_linux:      "f339a3905a04b10a4696b0e9988ad2d2207e94b83e2aea4573c92140f1c31da8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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