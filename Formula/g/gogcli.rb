class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "9a390fa206ccfa3a10201830fd4912048f4efbce949f8d6f04233727fc1c6547"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75fe38b466e107a32cf201f15d19b4550e43a0a6925aa97957c5ee071428d1b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4af0b95b8031f8ed894ef009376ea19073279495657a725689dd9be464c2b524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85e58ba66c7d41a2f32398bd5a0a191cd816d12911ac821263fc9b1ce2f402b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c62678b15adefc703539d0d6b00d1c9cbb2a61d4e6d6def6407f2091d4958ea3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28f35c183b83f9181f80adce415c8d1479d89d96f0c2f6c542f4629082a3c1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08342410a218f94da126a74cbc8e79807694bf7dafc8a86b9e551e9e93b94f61"
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