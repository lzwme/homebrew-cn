class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.13.0.tgz"
  sha256 "c2c12adb309f25c1920f1e4f385e8bea8879a68aa6b53e229f3e559c365add25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8bb704d158d0b2c22bce0d7632427f26fd9e4697d49b9f706713fa049dd766cf"
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