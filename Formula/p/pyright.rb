require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.341.tgz"
  sha256 "ca3f450700cc72b5e7893dbf5687834ea6366a64d60c4e45837d6c5f12336828"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75571509c6a37e1a6219cbfbe21556c18adf3b2c0b913ee059ee7eb5571b96e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75571509c6a37e1a6219cbfbe21556c18adf3b2c0b913ee059ee7eb5571b96e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75571509c6a37e1a6219cbfbe21556c18adf3b2c0b913ee059ee7eb5571b96e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3b3c88bffe4fba69964cc6294fc0e8ed8caba798989598faa9589068d5e719e"
    sha256 cellar: :any_skip_relocation, ventura:        "c3b3c88bffe4fba69964cc6294fc0e8ed8caba798989598faa9589068d5e719e"
    sha256 cellar: :any_skip_relocation, monterey:       "c3b3c88bffe4fba69964cc6294fc0e8ed8caba798989598faa9589068d5e719e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5c5c1daa5b09005cbca67875b3eb7806e846cf504dcee4d29f62ea383ea03c1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end