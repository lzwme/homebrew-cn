class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "292f8bba2bf53617105c08e9344052e90a851625d88c21274e137c61fbbe48a0"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af35055e311af233fb8c3b203aefab1b1ee55e4d0fff1b004abad8faf43400d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "338b078885f1caa41c8dd40ce6b1c0207e37afa2c2d30f9b9f28653aca6199ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9206c8c769f19a18a0a8d27f50c00bbbd65213c60eefb37abc91e54d448d827e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8d448f1431af4540ead0beb6e7cdd54f6362f39610d1463d4be86153bf82614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "017aaf44fc2f7b7bf94b22c94a9a8e760f13981d921330006e62bb24bfb337d9"
    sha256 cellar: :any,                 x86_64_linux:  "c1d8d6a215df4edc5b7596111399b7834f296c16d22b9321fac6a05d60f9aebf"
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