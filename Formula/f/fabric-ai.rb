class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.294.tar.gz"
  sha256 "1b3153c5962613c75afe80253fd33a4f7656ce466523ede8262eb2bc29ae17d8"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbe3d084ad44e95e594221d12c9024d8aa779080feba4c2a64d1260b7e5788df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbe3d084ad44e95e594221d12c9024d8aa779080feba4c2a64d1260b7e5788df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbe3d084ad44e95e594221d12c9024d8aa779080feba4c2a64d1260b7e5788df"
    sha256 cellar: :any_skip_relocation, sonoma:        "e712cfcbc4a22ad5c3063fc7f1ff6cab8a797d107ed75e9387c9d21f91dd1e7e"
    sha256 cellar: :any_skip_relocation, ventura:       "e712cfcbc4a22ad5c3063fc7f1ff6cab8a797d107ed75e9387c9d21f91dd1e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9984ecdff2a40580646c4668f2e2596687f19535f9c7ff4c0ac71f5cb805f1dd"
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