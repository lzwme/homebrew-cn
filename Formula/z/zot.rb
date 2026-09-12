class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.72.tar.gz"
  sha256 "f94aa181519c44a6f673786b4f4bf1246d247dc3271974644ff17fcca663773d"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f56950cd37803739d425b23b9d8efcd20d45bb32fb1754ad60cd49f8a023f23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f56950cd37803739d425b23b9d8efcd20d45bb32fb1754ad60cd49f8a023f23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f56950cd37803739d425b23b9d8efcd20d45bb32fb1754ad60cd49f8a023f23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5f56950cd37803739d425b23b9d8efcd20d45bb32fb1754ad60cd49f8a023f23"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "efdae35e39092eea4a7a88173d4b6f87590ce0a5486697f0e4d7808232f8cd05"
    sha256 cellar: :any,                 x86_64_linux:      "bc2c8516de3750e54fda79dd583b1345f140905cf41cbc3d969ace56cf9fc4e9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end