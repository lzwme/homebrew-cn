require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.306.0.tgz"
  sha256 "8c7e8c9ddc266d5e0fbd84f8eefd61f7f68657d52cbe74034094713b027585c8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43f26db4f9f93984d30e146211b4245a54befc5604222cff0c19653cbfaff7de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fa0edf7a5dc034b9bab8e0209cef32a9af61f5e7d515d8eadd09caca010ed9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fff59f22d839b8f016befa0ec2391827ec9ac60b5d33f174f3665b5e37a4c13"
    sha256 cellar: :any_skip_relocation, sonoma:         "4669ab6b29bf711b5fa7d0b33314e2933206ee7b84d42706c518b2df1d611d5a"
    sha256 cellar: :any_skip_relocation, ventura:        "ff51130735644198e1add0c0ee4d0509b34cb632d92a19e480324afc885ffaa8"
    sha256 cellar: :any_skip_relocation, monterey:       "e63ba8f013bf1b6f8f935aa943276a673979d17d13c3390d12739a6baaa5d3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e687746b6723cabfbd8fc6e82960cf4c4b8b5860c0dcfd9620531061dceda5f"
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