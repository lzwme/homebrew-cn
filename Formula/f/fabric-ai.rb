class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.311.tar.gz"
  sha256 "8ea167d7176c8a43205355e7e911d5871f889bcd678c561e94c39b53ce684ae4"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66b13ff677bffb0143e4a9fd23075fe829fe4c0edfff981dd2f2649e7ab73f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66b13ff677bffb0143e4a9fd23075fe829fe4c0edfff981dd2f2649e7ab73f74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66b13ff677bffb0143e4a9fd23075fe829fe4c0edfff981dd2f2649e7ab73f74"
    sha256 cellar: :any_skip_relocation, sonoma:        "755e528a0bc1f1fc34992e13b0c981916dbfafcabac0a0049932c01f0289dfe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "178cf5e5e5472c5504f13a1680153c6805c2f4791c2419167c06dcf395814b2e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end