class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https:www.usebruno.com"
  url "https:registry.npmjs.org@usebrunocli-cli-2.6.1.tgz"
  sha256 "b130251b8ff7121b6b788ce6da1ea225065cc6746e0ec4b514e5725842110a26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c5f10e1776ac03c81dc6009b90ec9c8e32603298c3a5175239a3bd5fa6f9f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c5f10e1776ac03c81dc6009b90ec9c8e32603298c3a5175239a3bd5fa6f9f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61c5f10e1776ac03c81dc6009b90ec9c8e32603298c3a5175239a3bd5fa6f9f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "695ef1c48cbccd18bb52a47fc43525120d60c7724c050667b837ad2ce2226e8d"
    sha256 cellar: :any_skip_relocation, ventura:       "695ef1c48cbccd18bb52a47fc43525120d60c7724c050667b837ad2ce2226e8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61c5f10e1776ac03c81dc6009b90ec9c8e32603298c3a5175239a3bd5fa6f9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61c5f10e1776ac03c81dc6009b90ec9c8e32603298c3a5175239a3bd5fa6f9f2"
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