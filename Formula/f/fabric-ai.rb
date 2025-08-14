class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.285.tar.gz"
  sha256 "ef24b336a50cc2cbaa287b63a095ea13046eb84c0f2c300a920a3c19c9220c7e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "febe2e9ae2639d32a50817f10a97fa9987e35045fa34afba5514f95fb64e5424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "febe2e9ae2639d32a50817f10a97fa9987e35045fa34afba5514f95fb64e5424"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "febe2e9ae2639d32a50817f10a97fa9987e35045fa34afba5514f95fb64e5424"
    sha256 cellar: :any_skip_relocation, sonoma:        "cad8e390ffb6f42215c30f5d7b14180fcb80e2c14479cdcd95d350889c565dad"
    sha256 cellar: :any_skip_relocation, ventura:       "cad8e390ffb6f42215c30f5d7b14180fcb80e2c14479cdcd95d350889c565dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5612554b341d4bc1988c68fb507b76a4026945da7026ddaa6d785b6aa7bebf13"
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