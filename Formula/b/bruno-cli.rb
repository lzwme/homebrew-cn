class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.0.0.tgz"
  sha256 "8688d9827112de5acda5982e2e1e7e726ecde3d63c2ca2926e154479fc84e3ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f012c32a6957dd2fc17168294d9af7e10bcbabd27a54b696a8f0760f79c05173"
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