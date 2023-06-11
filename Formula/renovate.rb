require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.116.0.tgz"
  sha256 "84e4137c4dbab0a86be715ac23d8bfb02749f51cddb72b2b9f86b89a3a7d3d31"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bec242c27cd26338c68a4da4a4241ed67cf8dd996bdb71ecd47553611422b43b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05b65194ee12f3a5b29d38b6e262258c1c76598a87e4e3406c44c195786a5925"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12c5ba2653017f3ba094c12722d9920c596b62dbaf455d65b53351d46eb4f485"
    sha256 cellar: :any_skip_relocation, ventura:        "b666bb88bcc3ac2ac17990ca1d5e9efb22599eb1df41c893662fd3aa3767226e"
    sha256 cellar: :any_skip_relocation, monterey:       "2a94e12cd5ac89bdd5a1e96bb2559ded99c833f97c8d7b911f9117ae4bdd9b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f945ee610454f98d6bf748ed178314542156f4908892e7599c119671e3238b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb7362aab24887af08792317b353bbb2246c084ef690b76aa4be538c7704e3e"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end