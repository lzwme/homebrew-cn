require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.128.0.tgz"
  sha256 "b80498e0cb99fcb0a54da3200b1464bf9d5c6d7bf5a6890608f8dd142fdedecb"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60c6dce6448ec5821b6e4efc94853546b61320324e2aa9fbbfd655a0609d25cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e05a8e5ea25efed6dec02f5be18f6e61870a28a888bc7b1e51ab7172328a13f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "320071dd0d1d06be2f4a1f22c4128da14305da578b64068fde2b1b700c96caca"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b56279a8105a46dea05d323ef892b5b5437cdef0b2288f82252fd8f6627ba4e"
    sha256 cellar: :any_skip_relocation, ventura:        "511a4ca07f897885b4f767802ee90e9a838ad9579ace7dd7984884ff245dda25"
    sha256 cellar: :any_skip_relocation, monterey:       "6b74f72a0cc7d7a3647c6bb244a4549386d2bfee1077f1cab95de4cc64b315fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18896c6877c67d30b44202ff6597d2e6ee649e83710f5d8c51b30d93394170fb"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end