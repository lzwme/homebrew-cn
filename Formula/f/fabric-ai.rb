class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.307.tar.gz"
  sha256 "f90fb73025941d31a3b742c1600c5d9fae870dde46fd41a1def49dfc28d000e2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdf2b7f29ed4ded1190a910e3a1e374d3797e19a163894406a214e9d830d3d64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdf2b7f29ed4ded1190a910e3a1e374d3797e19a163894406a214e9d830d3d64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdf2b7f29ed4ded1190a910e3a1e374d3797e19a163894406a214e9d830d3d64"
    sha256 cellar: :any_skip_relocation, sonoma:        "31f77c979a259801bea6585013fecb64b41c0ea432657a9cd2828f4c9a9a7dab"
    sha256 cellar: :any_skip_relocation, ventura:       "31f77c979a259801bea6585013fecb64b41c0ea432657a9cd2828f4c9a9a7dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "341fe7e57772313f52f3f9ec4adaf1987e086bb13dbba67759425853b1d5cb51"
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