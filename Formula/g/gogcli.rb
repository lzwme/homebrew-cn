class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "f6c25e03cb419d3f97f41c88fc46ed72b1848678a87e43c16232d2cbae2949c1"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d0b66003834502136c1fc7e72222ce04dfa2ddeee5ab5544677f7cc330d3f09"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d94daf498a5ea296f99db6371738a623f4bf2cbff8dc259a73490f4abd3f24c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a77ff684e80c81e1dda4fb326551d251cdd5b4874e1c81a84127f9c32d36eab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0e08e8d4cfe967e6ed53793a1db3642d7868d7ab5bfa18f4b36737906752176"
    sha256 cellar: :any,                 x86_64_linux:      "666dbb812caae86c44f6dc6725d1a733dce11b8b014514cd14f2ae436e784d99"
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