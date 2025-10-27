class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-8.1.0.tgz"
  sha256 "8fd9d55c2c06ef85516608256d17b4deedb23ab1bb8cd2d7ffd22f1af1d22185"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f14b7f075d26f0f39c4c2c8b1f65c586587ffd730970401b29b713bd57b60f9b"
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}/hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_path_exists testpath/"blog/_config.yml"
  end
end