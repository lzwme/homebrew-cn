require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.392.0.tgz"
  sha256 "4f650e07b5b08b8edf03dceea4d6f5c92482da6e13e706ecff768eb2993cc758"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5164113cedca957607256cb91f58e47405b292cfaf181fcd3a17fdb8c2ce2ad9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1a4d00e1bd355efcf2dbf11f99730df598199409af97623fd553205cc8d3e90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dc12c6e48f257be072ee60cfb39f06f54c1cd04243b8f73445795d704efe769"
    sha256 cellar: :any_skip_relocation, sonoma:         "45807930e5567e85f25078ab7fda8d9e00c0c42d14de7852fd990d91f6fd44c8"
    sha256 cellar: :any_skip_relocation, ventura:        "c4ae030b633f995242438d81bfeb7930a1eca41237656571c638a85a75cc8711"
    sha256 cellar: :any_skip_relocation, monterey:       "1ac145f24fe33acb66176ac032d354df627049b88a2684ed6579d4771001d33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "884ef0bfa7182de0e12fa0533a2d46e0963d6b8033876aac7027257100dc7971"
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