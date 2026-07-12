class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "5ae7664dc9e79c0aad57864551e9f7db2a4be3a995e34db7a54bb1d01cba5af9"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "778c6cf8ef4dfb92d88b7f920adb07774dedb7c8accf0042b6743496b8e9dc81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00cc6832ac327132404f71b819becaa89240b63ea1e03a708f8ce5cd308e85b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26f2c62558dfc51b67a45965689df7efbcf84b332c898dfa485eaf96d49a351e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b41c4eac5f69a3e13c7c90339895c856de860fefec5f67fad438fb4c7cf4b3ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aa29dcd0622100f50e6e54be8cbea162e73b1d19bff2dd357d1cde634c4317e"
    sha256 cellar: :any,                 x86_64_linux:  "bd72efce97a5d10806827156df76ee21925acf5f2b2c8302366d28a79d4671ac"
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