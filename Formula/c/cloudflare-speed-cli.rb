class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://ghfast.top/https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v0.6.14.tar.gz"
  sha256 "122344843ea9d3cb06ab8fab3b6e148e8b854322747c7aa2974e0faf4b9269a4"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "076b1bcbcbae1ed94cfa27f163bd1c53621be63444270846f4084accda744812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a05ec3d8dad3e14f6b2305ba436241fe5e4b44447c343d3c26c0e37e42a1eb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8052d396e3dd5be9445b105f9e6bc04667108d7489ececaa03d422b24f3113f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1b15c72a193a45ffb62d3a9e03964f13a2aea042c16638e5eb479c7e85dcc81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "692eded3cdc14fe4ffbc2bd83effdb5bc1387d2796cf63c9a2b9e6def4941a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e14227d49067e8bd8ba27744df3119e1cc1cc7ad2494c48d67e22661966c60a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudflare-speed-cli --version")

    output = shell_output("#{bin}/cloudflare-speed-cli --json --skip-diagnostics " \
                          "--auto-save false --download-duration 1s --upload-duration 1s")
    assert_equal "https://speed.cloudflare.com", JSON.parse(output)["base_url"]
  end
end