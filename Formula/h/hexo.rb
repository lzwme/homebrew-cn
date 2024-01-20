require "languagenode"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https:hexo.io"
  url "https:registry.npmjs.orghexo-hexo-7.1.0.tgz"
  sha256 "b46e98e5bc27682dc743c23657e1ac9e04c24c2f0cb5ea722cc4707d74b67865"
  license "MIT"
  head "https:github.comhexojshexo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e834d4bc8fa3ad5448bb9276d1713bd31a9e2a841ea97cfb1fad488f0ff3f56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e834d4bc8fa3ad5448bb9276d1713bd31a9e2a841ea97cfb1fad488f0ff3f56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e834d4bc8fa3ad5448bb9276d1713bd31a9e2a841ea97cfb1fad488f0ff3f56"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7b00a93dbb6853b9fb44cd5d666d1cf6e79761ed7a308babccb2ac65efdc835"
    sha256 cellar: :any_skip_relocation, ventura:        "c7b00a93dbb6853b9fb44cd5d666d1cf6e79761ed7a308babccb2ac65efdc835"
    sha256 cellar: :any_skip_relocation, monterey:       "c7b00a93dbb6853b9fb44cd5d666d1cf6e79761ed7a308babccb2ac65efdc835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5750264b036e08d6526315ac32385104ffbdfc939cc7edcfa7641d239738ded"
  end

  depends_on "node"

  def install
    mkdir_p libexec"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_predicate testpath"blog_config.yml", :exist?
  end
end