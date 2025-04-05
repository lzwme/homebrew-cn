class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https:www.usebruno.com"
  url "https:registry.npmjs.org@usebrunocli-cli-2.0.1.tgz"
  sha256 "a9d78aca0c6f4c3b4859e5ce1e84c6bb24fc4f4071dd8f5a68417f76068ebd6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13024b2ed820961ff2ff4b03b927b655534107f77dafd15dd9b32d4663139880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13024b2ed820961ff2ff4b03b927b655534107f77dafd15dd9b32d4663139880"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13024b2ed820961ff2ff4b03b927b655534107f77dafd15dd9b32d4663139880"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b53bc574c37d80d9d994679644c5aaf44b5255c7fb65e6ac220b5a9c85ec4c2"
    sha256 cellar: :any_skip_relocation, ventura:       "7b53bc574c37d80d9d994679644c5aaf44b5255c7fb65e6ac220b5a9c85ec4c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13024b2ed820961ff2ff4b03b927b655534107f77dafd15dd9b32d4663139880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13024b2ed820961ff2ff4b03b927b655534107f77dafd15dd9b32d4663139880"
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