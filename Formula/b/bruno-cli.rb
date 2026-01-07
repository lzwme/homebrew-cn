class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.0.1.tgz"
  sha256 "a73f178472c8362500b6a5d8253ffc851e6990602902d2244366a48a195daad2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35765012340fc2c686ad8aaac9e0b998cb36bdc789ff90bc5bd4cf33dcaa93e2"
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