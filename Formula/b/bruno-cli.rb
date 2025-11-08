class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.14.0.tgz"
  sha256 "55462ddfe2b0419178901fdbe722298465cd969ab941ce8898eda2dc739496d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7f535267a26a0f159878320e7a9b40b9a056345bb4365367a83f7cabe12198bd"
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