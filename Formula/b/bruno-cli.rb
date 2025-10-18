class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.13.2.tgz"
  sha256 "043115f418dfbd7eac6058a14c38a6d605f5ee3c99c519331376136502c2b883"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d5e08a1f8b1c9f4379496be6ef473e20d779d18f9ad279aba1d69f6ec676730"
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