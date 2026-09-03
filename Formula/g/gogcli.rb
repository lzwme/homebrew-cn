class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.38.2.tar.gz"
  sha256 "dff5fd0999428fa39fe3b276fd66f962899b9f29de2a0b958958c46d49ef5a00"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd310b8f35d21bb56d3f8c479097b4385e936a28e529764565bc7b8824749588"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "531c773c7fc191ccefeda7dc19ed1eaf9d3866b513f58c2ea1cfdd4115900721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80e18abaca9dc3f2c21a140fefce59c09b2fce51b29d024e75b67bd2bb5cd9c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a3ed685cc5b3c9f1fc58a3bb95c8464b38f750874c7ddf09dc7769baf5de8f0"
    sha256 cellar: :any,                 x86_64_linux:  "74639092ae84bf887ca8ac630a39b11caaa277ce1f6f6cc062e7aa9e5703960b"
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