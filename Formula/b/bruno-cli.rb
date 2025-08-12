class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.9.1.tgz"
  sha256 "401a767db275960fc7344c3ab662c8ce656478227478152492c314609d67db33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2983cddb9a10dd3eb58d5643d0c388578f2b311d3096eafa9d16a4c385880fc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2983cddb9a10dd3eb58d5643d0c388578f2b311d3096eafa9d16a4c385880fc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2983cddb9a10dd3eb58d5643d0c388578f2b311d3096eafa9d16a4c385880fc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5363b5ba539da103b2af9953621e62955b65b4c3e4f3a41da7e65cca3e735860"
    sha256 cellar: :any_skip_relocation, ventura:       "5363b5ba539da103b2af9953621e62955b65b4c3e4f3a41da7e65cca3e735860"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2983cddb9a10dd3eb58d5643d0c388578f2b311d3096eafa9d16a4c385880fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2983cddb9a10dd3eb58d5643d0c388578f2b311d3096eafa9d16a4c385880fc7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}/bru run 2>&1", 4)
  end
end