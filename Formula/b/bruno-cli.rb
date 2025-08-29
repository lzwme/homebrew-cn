class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.10.0.tgz"
  sha256 "fbfb0061a4cbe597a6f3a7aad89921675819a18c0888b2845bb8acb3a24f35db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4955985fd5e13804791e935140bbd826d625a106a3582789e59140d19e134484"
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