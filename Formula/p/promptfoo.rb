require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.54.1.tgz"
  sha256 "d1d42348a0262c225248ea1c550b6a29a4164c09c84ab8c66db2602eaea21210"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b604cea700986c2ac33e97b3c717d95147daf6250728919154f8b45fda1346a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a592b67bb2ca832abd6da641d9a89dcca2ef0589364a1cc9bed0d338658bc878"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ea7f260595860133d65be598cd8fcf523cb3261292f39f49bdfce99af68d291"
    sha256 cellar: :any_skip_relocation, sonoma:         "43d1a1de5d6e9e5e29f942514c8d84b2712903533b9b1f3a82d91b41672c5418"
    sha256 cellar: :any_skip_relocation, ventura:        "110b2ede4420cf8268d36f9de447c44575356ffb545206d7584385eb62d63246"
    sha256 cellar: :any_skip_relocation, monterey:       "bda8f942c2cee71053eb864e1fba0e34eb73007ba4d58ab841c568da55fb4a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7833fdb0f57884bf9b8236a1154fc0bfac7781a6713f14ea6960f83cc982b263"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"promptfoo", "init"
    assert_predicate testpath/".promptfoo", :exist?
    assert_match "description: 'My first eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end