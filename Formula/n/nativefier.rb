require "languagenode"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https:github.comnativefiernativefier"
  url "https:registry.npmjs.orgnativefier-nativefier-52.0.0.tgz"
  sha256 "483c4fc8e941d5f870c610150f61835ff92ee313688bd3262cf3dca6fb910876"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e752430f545faa200121374e77a086329a1d9bd6c00e90f77f72e6cce8553ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d43221afa1e9e1cf3cf8e09ae10f485602f7be6951e2e8f2a92a8cbdfc3325fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d43221afa1e9e1cf3cf8e09ae10f485602f7be6951e2e8f2a92a8cbdfc3325fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d43221afa1e9e1cf3cf8e09ae10f485602f7be6951e2e8f2a92a8cbdfc3325fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "455b791378f61bb5670bcec324beb48a61e0b2d86189849bdca6d7a927dad5e9"
    sha256 cellar: :any_skip_relocation, ventura:        "81d8ff02c4ab134272fb633f797551e98c1e6bce213fff65b52a178017f7b64d"
    sha256 cellar: :any_skip_relocation, monterey:       "81d8ff02c4ab134272fb633f797551e98c1e6bce213fff65b52a178017f7b64d"
    sha256 cellar: :any_skip_relocation, big_sur:        "81d8ff02c4ab134272fb633f797551e98c1e6bce213fff65b52a178017f7b64d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d43221afa1e9e1cf3cf8e09ae10f485602f7be6951e2e8f2a92a8cbdfc3325fc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nativefier --version")
  end
end