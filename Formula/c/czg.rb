require "languagenode"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https:github.comZhengqbbbcz-git"
  url "https:registry.npmjs.orgczg-czg-1.9.4.tgz"
  sha256 "d005cdff971561e70fe64d615ab67e60d5eba0e8f9dd8994fa22b54f861f9b47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25f077613768332129dd88900f73ba1ce2c6084e11003208da001dc264dc75d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25f077613768332129dd88900f73ba1ce2c6084e11003208da001dc264dc75d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25f077613768332129dd88900f73ba1ce2c6084e11003208da001dc264dc75d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "25f077613768332129dd88900f73ba1ce2c6084e11003208da001dc264dc75d7"
    sha256 cellar: :any_skip_relocation, ventura:        "df2c96cae02377b590b7c1bb83d68f8574fc10ee1db2e491f0a3b88f63172752"
    sha256 cellar: :any_skip_relocation, monterey:       "25f077613768332129dd88900f73ba1ce2c6084e11003208da001dc264dc75d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a36ded1af7e80799e311d873c7a23cc41a4378d0d6546cd9969de8e5c97177d9"
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