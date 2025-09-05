class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.10.1.tgz"
  sha256 "382dbc6592a5182e4641465cc05680f38063dfa332a97dd318772a773cb7c9d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed224029549a01d27171d53310254e38fac1546a6336c6adec2d920878b652e9"
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