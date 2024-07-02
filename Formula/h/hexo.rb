require "languagenode"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https:hexo.io"
  url "https:registry.npmjs.orghexo-hexo-7.3.0.tgz"
  sha256 "807b356fef2aa9623788b0e2b997fc6955c4c0a2a70fc1a8776c281194e4277e"
  license "MIT"
  head "https:github.comhexojshexo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cdc68c835619a51bb1b89cf75a9c2d7ca03e0784008dd5f02999bf4e8f6ebb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cdc68c835619a51bb1b89cf75a9c2d7ca03e0784008dd5f02999bf4e8f6ebb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cdc68c835619a51bb1b89cf75a9c2d7ca03e0784008dd5f02999bf4e8f6ebb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e928e99e2d1a58a06a8449d6180dc4838bf0486a9c0b66546c8d75ba5daa08ab"
    sha256 cellar: :any_skip_relocation, ventura:        "e928e99e2d1a58a06a8449d6180dc4838bf0486a9c0b66546c8d75ba5daa08ab"
    sha256 cellar: :any_skip_relocation, monterey:       "e928e99e2d1a58a06a8449d6180dc4838bf0486a9c0b66546c8d75ba5daa08ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5d0f8b4bfd2f07eeeff81162960f76f5d87be53b32f668fb7c3aac49e2e1367"
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