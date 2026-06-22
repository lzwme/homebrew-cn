class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "3d49163de18d1e8a70d760528fdd2e54615950a1d03fa6be8653d0bcb5562e17"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "449d116019f69fa8bf4f53d4f916426e4626027f6eb1cb5ff6cf5e0911d33ea5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30dc2f47b314214e96bea99495b10ea740c5d1154f70b6f7ea6f6d8cca0d2240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0849faff38e8365a7df3d88d330d9c959808d4caaadb3a59de84b2919ef4e2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d81034c8a8e27c264051b88937a5dee47fdf6b848e6f15abe74355f78402c68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b34d0211c25f611d03dde85f65ea9a2b27b8290905f84369ee6b6cd73f1385c3"
    sha256 cellar: :any,                 x86_64_linux:  "c5d5ccf5b2944bbee8b4a5185a61b8f241102f9812980b7a1c40ddefa48851bf"
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