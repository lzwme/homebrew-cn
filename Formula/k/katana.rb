class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://ghfast.top/https://github.com/projectdiscovery/katana/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "f3eb8efc365d4f9287ba4035e8903981a2c50e82ba48ec020aa1de26e52afb14"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49e8cd864657d41c6128699a629519be72bd98dcd7b2ba005d9a2772c17d7775"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b22ed4470e2563ec92ec81f973b0ce3e1e0486b4326cb1b9ab79bd711f93ddc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "608b126dbdd0c60c00fe2e6f1d255f3a37a7bb7ff6e07c81da10c6a7b730a612"
    sha256 cellar: :any_skip_relocation, sonoma:        "39a850cbc1505d5b74034e15a382fa9b180fe3f3db44f1d48924d7ac6dc62a5e"
    sha256 cellar: :any_skip_relocation, ventura:       "6056e5c4a76138b5a789d3200b9878be866e868cc2f155f97ef900d30523a699"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d13954ede657fe273f879eeebe4c418447c79f89dc88b34e836ef633c00c8a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5099a60eb966beacacc897fb5b6079322f248d4200ad99358f7c402dc4a99a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end