require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.21.tgz"
  sha256 "03b1e96ff865fafa1b93532d9585668933498987402e737c4d251223d01858d5"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17d9814183339ee7ff6382659e0dac5db96a487e18d930cedef60848c867c8ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17d9814183339ee7ff6382659e0dac5db96a487e18d930cedef60848c867c8ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17d9814183339ee7ff6382659e0dac5db96a487e18d930cedef60848c867c8ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4cdefa9ff67d1f64053863c27a1ada6f9f69acb8567159651cc42e951ddfa22"
    sha256 cellar: :any_skip_relocation, ventura:        "e4cdefa9ff67d1f64053863c27a1ada6f9f69acb8567159651cc42e951ddfa22"
    sha256 cellar: :any_skip_relocation, monterey:       "7860f13e83ebdcf0f13f953c17ee2385535e1b72e169aebd23109973d35d6c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d9814183339ee7ff6382659e0dac5db96a487e18d930cedef60848c867c8ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end