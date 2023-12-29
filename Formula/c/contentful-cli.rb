require "languagenode"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.1.35.tgz"
  sha256 "c77dd39ce332fd7efddc4873ab42d8c21d45724918b3c407cfd71390585ee466"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "805b20faf6a9549c3cf945a18b4497febb01c03f7814a430cfa7cdd633eecf6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "805b20faf6a9549c3cf945a18b4497febb01c03f7814a430cfa7cdd633eecf6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "805b20faf6a9549c3cf945a18b4497febb01c03f7814a430cfa7cdd633eecf6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6659e828da81d4a5bce4edd7d533afb7cc258038888a337f48210422b50b6f6c"
    sha256 cellar: :any_skip_relocation, ventura:        "6659e828da81d4a5bce4edd7d533afb7cc258038888a337f48210422b50b6f6c"
    sha256 cellar: :any_skip_relocation, monterey:       "6659e828da81d4a5bce4edd7d533afb7cc258038888a337f48210422b50b6f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "805b20faf6a9549c3cf945a18b4497febb01c03f7814a430cfa7cdd633eecf6d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end