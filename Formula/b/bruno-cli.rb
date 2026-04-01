class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.2.1.tgz"
  sha256 "51839daf47d6d4023af1e5ff27bcd9ccf308e73f25f9ee74e4e37af134da5638"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3445a1396d2afa67b81586d351674881175bd6049a54a9888e2b4e3c17ae2d74"
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