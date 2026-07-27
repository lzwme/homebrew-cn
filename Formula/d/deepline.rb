class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.279.tgz"
  sha256 "511b5bb5b4c9781e884377f8931a1eacd210ccc1c6c467a0f15323831cbdd325"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fc92833f15dece84fd51d085e7c647e1cce982ed1524b273c75429b56e1c63d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fc92833f15dece84fd51d085e7c647e1cce982ed1524b273c75429b56e1c63d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fc92833f15dece84fd51d085e7c647e1cce982ed1524b273c75429b56e1c63d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c45683a7009ff386ffd56f8ce1d960cf37a1bd6ebb4d4ca49a7062d5934d435"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a53b67de293176b6673f1f756c3b21bef6c62a311f4f860c92ad4b5afc194f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3445400c709c4a877b31b1b9d94db278d104d8015fe814c61a6de8cadb07ea37"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end