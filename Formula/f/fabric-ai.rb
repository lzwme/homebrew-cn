class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.261.tar.gz"
  sha256 "fa8b6fdec71082588dda0cf13f8d429ec0a009e87845fa480d6649b3d06bcde0"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec93d50e926ff0e8f96ce21c56f0d30153ec9fa90addd3304153d45660982149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec93d50e926ff0e8f96ce21c56f0d30153ec9fa90addd3304153d45660982149"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec93d50e926ff0e8f96ce21c56f0d30153ec9fa90addd3304153d45660982149"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ef63f351ed3d214c84b4f4a2200fbd88c4478bd8453530290e40904d73bb9af"
    sha256 cellar: :any_skip_relocation, ventura:       "2ef63f351ed3d214c84b4f4a2200fbd88c4478bd8453530290e40904d73bb9af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddf9b158181a9a6f1adb41184a2fd8a69462da5a1df6030cfe5a136efeb3e514"
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