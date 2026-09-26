class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "3e898748f902c30336eca78191dd067bd2ce7e912d879ae583bf376fbb414a54"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f45d2463298b8861896506bb53c645f98a8605975508399b0c5b7dee327501b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "383da39e9cf62aa4c869294ede8ddd78c7bdc5fc33a4235cf3cca225d2d90459"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "814250931fdde5d570f95c1429bf2fa9a84f8ff15912d541054472378e7b6a3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b18f3a52a5a12e6a46c5e11910ab5e4c0d0e0d1c239611f4d6d6d57117369851"
    sha256 cellar: :any,                 x86_64_linux:      "abadd9f67be106b357555594b2ed16c101e021feb048632281a9fb093374d95d"
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