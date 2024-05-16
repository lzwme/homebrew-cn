require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.363.tgz"
  sha256 "fb64a8585c54b73ab64226bd6b85a3bc7d2a0ed481e4ea0fa0fabdb2731066e0"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1577ad605762eb1f0699ed0e151374f8dbdc781249dbf311ad85c07e995abf7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0bd927deb5b6bf4dd4920b320695ac7ca1e859baf9cfbd02c7703445356ba41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3618741787630301de43c6975898af434d75430909c8d552a2018ab8a5b42eb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c8a11de9fd9ac03a42f5cd41a3281661811843f22bbc3a65cc4198fd8bb812a"
    sha256 cellar: :any_skip_relocation, ventura:        "731da542f0bf602f5ee461f84e34346a7d2b0017282ec0409382e4b5ecc0a028"
    sha256 cellar: :any_skip_relocation, monterey:       "951d8957d7284a65840103f693e260b7d3874122708f0ca0f25e924e8b80a389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44e80165d32731aaf23080dd18f9f1dd4be933762a71035198723382bd5c8cbc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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