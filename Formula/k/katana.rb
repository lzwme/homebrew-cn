class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://ghfast.top/https://github.com/projectdiscovery/katana/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "e49a8ac7e28e55b925cc8ebfb8d999dcb9ec8bb81e17f315573a3ccb17397d88"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12b8dbd4b10ea6fb55eaaa70c9e044838542c6663c917b54a4042bd22be2f243"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a463ed5d214eccb1ea7870626917792b377d2ed1cb326b90a30a6b8b494d654c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b922d8e2e21f1aa6602fc68c14f2c340f99349258f34bf93b7abee996039036f"
    sha256 cellar: :any_skip_relocation, sonoma:        "490d5d05405115d724303bedf028b74d55e83016b9f608d65c283250ad01e29b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bcf9897d8f126ebf8b7a1c38a2a7b3bcdbc5f7e9088b917f27526cd2b76268f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c567edd40711fce8d3f1b74ee568d4c5614d2812d2165f43828faa3ad2019e66"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end