class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.240.tar.gz"
  sha256 "e4d43947aec29e3e35d567774d66bf03b9ace7e219beef8753abd798bf764a09"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d28834ab5b0085f6d8fde8190411c2ce66688efecc0949557c7622c960d2cade"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d28834ab5b0085f6d8fde8190411c2ce66688efecc0949557c7622c960d2cade"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d28834ab5b0085f6d8fde8190411c2ce66688efecc0949557c7622c960d2cade"
    sha256 cellar: :any_skip_relocation, sonoma:        "c671c8955a516cf6a8ea96e7ff02e7f5375373bfa10c2b01d6d98b8c0c8eddb3"
    sha256 cellar: :any_skip_relocation, ventura:       "c671c8955a516cf6a8ea96e7ff02e7f5375373bfa10c2b01d6d98b8c0c8eddb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b3bcbb1518d8f5a8adb33c62ba07f2d78d754eb9f5173fe2f3ca80fe58dc34"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end