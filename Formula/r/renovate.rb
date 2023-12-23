require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.107.0.tgz"
  sha256 "4748e494b089b0903c9b7c65092660f3b356efd1b974ddcc71db7721e609626b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b281a7418df1eb0df0ac377cb81b0d6701ebcdbca4922da992964847459e9c9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e0bd0c209cc54302b31dfd14faed4e9867e4a78c7f2806698430345d5ff7583"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07e240e398976a4b57cd492549439200aa686e296afb168260f14eb90cce74c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a93787cc14a3a70ab8fc569e3de3ce331d1dc6b82abea640ef369a96861101bd"
    sha256 cellar: :any_skip_relocation, ventura:        "aed49a3df860bd08a8d24b9f549e9e923e9739c3a35396253048307043ed63a1"
    sha256 cellar: :any_skip_relocation, monterey:       "901126226a2c85ac0ef9b17fc1413473f6b7b3040beec58e4b8e4b316258d037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f4d3c7a6b48d0d98e8439396ddea9370559fdd89df278f8ec4dd1200c5fce4a"
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