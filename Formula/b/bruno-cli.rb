class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.14.1.tgz"
  sha256 "98b3f49229c90021d4d32f13c4d7691610586ad25e2c4eff522c7f1bfcae9dfe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8e2d2fd54b9d3e731d13133a4d6ffacc61e6bb2b95f879c82bc142ad05a48c3"
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