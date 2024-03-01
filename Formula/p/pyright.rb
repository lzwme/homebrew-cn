require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.352.tgz"
  sha256 "ef78138a907f21518082441b691f296850a938d33e6a17e5a6bf9a0d453a9bfe"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c565d978e78ba906a2775be5e7469f36c7078676730e17bef128e757f02ad21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c565d978e78ba906a2775be5e7469f36c7078676730e17bef128e757f02ad21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c565d978e78ba906a2775be5e7469f36c7078676730e17bef128e757f02ad21"
    sha256 cellar: :any_skip_relocation, sonoma:         "38f1920d829ad42ee69d97248558d86335b2be646d485f3d10b8ff41f825052e"
    sha256 cellar: :any_skip_relocation, ventura:        "38f1920d829ad42ee69d97248558d86335b2be646d485f3d10b8ff41f825052e"
    sha256 cellar: :any_skip_relocation, monterey:       "38f1920d829ad42ee69d97248558d86335b2be646d485f3d10b8ff41f825052e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26e69db2bf84fbf571882a44ee0fd866cb1468ff6516f1873cf4d4ea886440f1"
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