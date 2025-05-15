class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https:www.usebruno.com"
  url "https:registry.npmjs.org@usebrunocli-cli-2.3.0.tgz"
  sha256 "c7e6aa0ab54a344ac4da106cbeb49b7ab9c85878902c983ed2882e8450922c7f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65f7119eea1e8e383a59d99ce89c8bb3ba91f0282981a337d5491ef86590f153"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65f7119eea1e8e383a59d99ce89c8bb3ba91f0282981a337d5491ef86590f153"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65f7119eea1e8e383a59d99ce89c8bb3ba91f0282981a337d5491ef86590f153"
    sha256 cellar: :any_skip_relocation, sonoma:        "b365db60f801d4f83ac0a38ae2f870e5d2fb1ab2ac128e8ee1d46691d099fedf"
    sha256 cellar: :any_skip_relocation, ventura:       "b365db60f801d4f83ac0a38ae2f870e5d2fb1ab2ac128e8ee1d46691d099fedf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65f7119eea1e8e383a59d99ce89c8bb3ba91f0282981a337d5491ef86590f153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65f7119eea1e8e383a59d99ce89c8bb3ba91f0282981a337d5491ef86590f153"
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