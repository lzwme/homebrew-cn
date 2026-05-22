class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.4.0.tgz"
  sha256 "205fc86ae2be5203dd0769b4dc00437e60e7d0dccdb02ec528a16d1ced6f2d0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d5ac3767ff30b04faaeaa0990d485d4ef89a4dac023e2b3e4b5caed3dfb2e63"
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