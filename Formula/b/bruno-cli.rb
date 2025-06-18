class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https:www.usebruno.com"
  url "https:registry.npmjs.org@usebrunocli-cli-2.6.0.tgz"
  sha256 "6f90040703de5c9d0e9cdf99ea9231350fed1a48b41e4d6d35a8dca0bd6ab109"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "887868034d819e89df562a3e52f5355ec65aacdacd33dfc6531e5a35e6c3fce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "887868034d819e89df562a3e52f5355ec65aacdacd33dfc6531e5a35e6c3fce4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "887868034d819e89df562a3e52f5355ec65aacdacd33dfc6531e5a35e6c3fce4"
    sha256 cellar: :any_skip_relocation, sonoma:        "27f78613b8d60e5d7826da1d83968e818961bc7458cbe9799f915b8dad40041a"
    sha256 cellar: :any_skip_relocation, ventura:       "27f78613b8d60e5d7826da1d83968e818961bc7458cbe9799f915b8dad40041a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "887868034d819e89df562a3e52f5355ec65aacdacd33dfc6531e5a35e6c3fce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "887868034d819e89df562a3e52f5355ec65aacdacd33dfc6531e5a35e6c3fce4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https:github.comusebrunobrunoissues2229
    (bin"bru").write_env_script libexec"binbru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}bru run 2>&1", 4)
  end
end