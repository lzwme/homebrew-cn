class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.17.3.tgz"
  sha256 "be803a24d595e2225aec7e400e52976d44caecf0594a468600f38a6f381137c0"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfa3edee6d9ac4b18f8b2ccab3bb740df54884bb7802767c60ca614505da98ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfa3edee6d9ac4b18f8b2ccab3bb740df54884bb7802767c60ca614505da98ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfa3edee6d9ac4b18f8b2ccab3bb740df54884bb7802767c60ca614505da98ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a07d705ed34b3d8ca5a789e1f262115a5e7f078fd92b7d959c883227b624db9"
    sha256 cellar: :any_skip_relocation, ventura:        "2a07d705ed34b3d8ca5a789e1f262115a5e7f078fd92b7d959c883227b624db9"
    sha256 cellar: :any_skip_relocation, monterey:       "2a07d705ed34b3d8ca5a789e1f262115a5e7f078fd92b7d959c883227b624db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa3edee6d9ac4b18f8b2ccab3bb740df54884bb7802767c60ca614505da98ae"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec"binpyright" => "basedpyright"
    bin.install_symlink libexec"binpyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}basedpyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end