class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "66a4eb3afe9ba126c1689aa1de0d78c9e34d43a42a0bd6a645816f8159863f89"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "652e50ba13496ed23e5de366b264b49a98ff9cb7c1ec3c79b5eb212e3805a551"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a9ea7023b1da4a8b0fc8e65a93d01b395303c9bf4570f998eb3a0ce61289090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2f16265354db771ec7e411632fc0e8307e9470faec07a215b43efa7d4917b75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f9f7ec2d0f31ac47b6b982d1551535dd14a0886cbbe2d2aa5838d5e3eb7e1eff"
    sha256 cellar: :any,                 x86_64_linux:      "d69d7869439f0f45508e766562c87e68cb821ae86954c5aa82e1822fa30d56fe"
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