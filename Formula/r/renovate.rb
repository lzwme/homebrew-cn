class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.245.0.tgz"
  sha256 "ef0dc657dcc2b34f1a365f7228ffb2bb4e34541488dbd1fa579e905f8ad4a8d2"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949c7afeed36259ded8f57c7eeee472660921bfce146d5c1cb1d326491b3ea8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4072f91f623ff5f9e3aaceb53633415bcbf2b02273136ff30ffae02c0bbc9352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b593284352d3215a94e0a9803b90660cd6d2ae2715be9e82c7cc2e70ed0b055"
    sha256 cellar: :any_skip_relocation, sonoma:        "325a5aef8833191bd5fada3e56babb63601b762b9d53223e9237d5465a7ce946"
    sha256 cellar: :any_skip_relocation, ventura:       "aec1e491687f87f5f690d8ad43fdbd153775fb14874cd6774114eecab6e03e25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60a711ce96a4ffff00690a8256df3b6eaceb7fefa968cf2d6b47e04595ee2a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c4792f27e8eceed41ce01be110da0b39ff4ea76574bef289e0b930ccf2a667"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end