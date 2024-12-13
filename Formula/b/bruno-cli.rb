class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https:www.usebruno.com"
  url "https:registry.npmjs.org@usebrunocli-cli-1.36.3.tgz"
  sha256 "306960cae30c183fa219527c4898dad71ee6236c8651fa028b4db711d38e5d67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe9a96affa1cad1d328755860183241ce6bf60cd758c4207c5c906ad8541beef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe9a96affa1cad1d328755860183241ce6bf60cd758c4207c5c906ad8541beef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe9a96affa1cad1d328755860183241ce6bf60cd758c4207c5c906ad8541beef"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9629275dcd9ed700d7959933b79765dd77e71a14793b252341733566b7cf255"
    sha256 cellar: :any_skip_relocation, ventura:       "e9629275dcd9ed700d7959933b79765dd77e71a14793b252341733566b7cf255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe9a96affa1cad1d328755860183241ce6bf60cd758c4207c5c906ad8541beef"
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