class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-8.0.5.tgz"
  sha256 "210ed579cf6d37c0ac93df78c6fd52fee67f392485a92ac7b42ff38cc3030751"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27d1d185717526f91aac8580a704e5daa317e6e98384b87624b91e6af97d71cd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"script.js").write <<~JS
      [1,2,3].map(n => n + 1);
    JS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_path_exists testpath/"script-compiled.js", "script-compiled.js was not generated"
  end
end