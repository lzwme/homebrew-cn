class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "86a898b69c53149f8ebec535d0fe8eae7b80c6d3e10f59f57b45b3e9eb7b87d8"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69afd178d97d43336372be7c871ecc387f769322e3d51f0ad59e342504704313"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fbda36de40776ec024f2d9c8b06107567d332cdf6b11966b526f0d71a94e467"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4454b43eaf2dee9a1efcc847fe3a843dd26915fa037e24ad771853bf92f849a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6a5d9302233f5548d2ae3079654fbc1231812741b4a4206eb724e1ea9fa1e21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5c2e3f26cb15c55ecd25336c0e79d20b302c428fc984a99fc6b317443598876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21ab60966379bd19024315e1d7cc6b4d1a70eaf3e77deede6e96a48d7239edf9"
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