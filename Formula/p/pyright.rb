class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.377.tgz"
  sha256 "b11dc22e92560b38ebad99a892544d9ce81e2ce995db430b3683e86db57d7710"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3762bbf4d82891755e2475ef3dabc440a94bdd81b1f050387aa8fa2182d270f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3762bbf4d82891755e2475ef3dabc440a94bdd81b1f050387aa8fa2182d270f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3762bbf4d82891755e2475ef3dabc440a94bdd81b1f050387aa8fa2182d270f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ec471c13bf01ba31babe8ace50bb840ee03a398c7ab0671078af3d0f7fae6d2"
    sha256 cellar: :any_skip_relocation, ventura:        "3ec471c13bf01ba31babe8ace50bb840ee03a398c7ab0671078af3d0f7fae6d2"
    sha256 cellar: :any_skip_relocation, monterey:       "3ec471c13bf01ba31babe8ace50bb840ee03a398c7ab0671078af3d0f7fae6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3762bbf4d82891755e2475ef3dabc440a94bdd81b1f050387aa8fa2182d270f7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end