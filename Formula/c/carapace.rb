class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://ghfast.top/https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "92adf835224c05e3cc05746a665085b0f9d3a2a2cc079384084ad8e0d3346de8"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24a606653e01d7a7a6c1238087f3f5802f9100f6334b43f02ad5957053263c4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24a606653e01d7a7a6c1238087f3f5802f9100f6334b43f02ad5957053263c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24a606653e01d7a7a6c1238087f3f5802f9100f6334b43f02ad5957053263c4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "63665a9a90a92a6f3ea2f82612c2603f2b6824ab3afa53fe1f3ab7b8da59c84b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c3fd7c420c58173c399195a0c99a024893c5ace63d0dca92b0d9ea9c568a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "607377095af37b0ba65ab9350004d7b7d0bb60f54b509deb611fe927f20082e2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end