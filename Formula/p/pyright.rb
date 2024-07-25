require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.373.tgz"
  sha256 "78446d6cd4e925e4444ab46bc442cd76f6f9adeae3e986e883c2d9c4909f7264"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5baa5f131fbe2977730b0e54a3492aebe22249e0c59c85160d2d38f9d1a8115c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5baa5f131fbe2977730b0e54a3492aebe22249e0c59c85160d2d38f9d1a8115c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5baa5f131fbe2977730b0e54a3492aebe22249e0c59c85160d2d38f9d1a8115c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7af74e3be715d7c4abf851822b689a2431a3c8fa8c40f5596536eac9a42f650"
    sha256 cellar: :any_skip_relocation, ventura:        "c7af74e3be715d7c4abf851822b689a2431a3c8fa8c40f5596536eac9a42f650"
    sha256 cellar: :any_skip_relocation, monterey:       "c7af74e3be715d7c4abf851822b689a2431a3c8fa8c40f5596536eac9a42f650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cadf90c0e1b926d700b3f28fc91b0e014dd94230e12a0b6bb4bb599e2ffd4b9a"
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