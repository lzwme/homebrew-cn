class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https:www.usebruno.com"
  url "https:registry.npmjs.org@usebrunocli-cli-1.38.1.tgz"
  sha256 "85df13ae0a5944b02d20da7a8dd0ed72de41b448befd0a880a0a8a806bd9a285"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b8da7a83da02a635a4ffe888c71233dd35543de4b05b41fd875e18abf1f3573"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b8da7a83da02a635a4ffe888c71233dd35543de4b05b41fd875e18abf1f3573"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b8da7a83da02a635a4ffe888c71233dd35543de4b05b41fd875e18abf1f3573"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b625a32273cd7b1a5acff71493a12aa897d40a806e1c50186eb67f73a18e46e"
    sha256 cellar: :any_skip_relocation, ventura:       "1b625a32273cd7b1a5acff71493a12aa897d40a806e1c50186eb67f73a18e46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b8da7a83da02a635a4ffe888c71233dd35543de4b05b41fd875e18abf1f3573"
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