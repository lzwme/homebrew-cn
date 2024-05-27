require "languagenode"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https:github.comZhengqbbbcz-git"
  url "https:registry.npmjs.orgczg-czg-1.9.2.tgz"
  sha256 "776cdf79e92fa9a7edbce5d582e98eff0db5ccb4b35f50f80f605718161ab0be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc438d10f8a7239f5cfca51975f6e07e8d194acc6eb4fd8bdee3918988eddff8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc438d10f8a7239f5cfca51975f6e07e8d194acc6eb4fd8bdee3918988eddff8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc438d10f8a7239f5cfca51975f6e07e8d194acc6eb4fd8bdee3918988eddff8"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc438d10f8a7239f5cfca51975f6e07e8d194acc6eb4fd8bdee3918988eddff8"
    sha256 cellar: :any_skip_relocation, ventura:        "dc438d10f8a7239f5cfca51975f6e07e8d194acc6eb4fd8bdee3918988eddff8"
    sha256 cellar: :any_skip_relocation, monterey:       "dc438d10f8a7239f5cfca51975f6e07e8d194acc6eb4fd8bdee3918988eddff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee4edd9c9f1702183c1bbcff7b750a9e4b872264a3f97243216b754825cf1924"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}czg --version")
    # test: git staging verifies is working
    system "git", "init"
    assert_match ">>> No files added to staging! Did you forget to run `git add` ?",
      shell_output("NO_COLOR=1 #{bin}czg 2>&1", 1)
  end
end