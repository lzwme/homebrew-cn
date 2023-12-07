require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.339.tgz"
  sha256 "fd02d07de17944c498547a6cc2834daccd29540037fe12260e521b294da427ed"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2e2009eef81e75a6fff292961258384228cb2499771e77fabc533acb2a5904d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2e2009eef81e75a6fff292961258384228cb2499771e77fabc533acb2a5904d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2e2009eef81e75a6fff292961258384228cb2499771e77fabc533acb2a5904d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4edec79f8504ed2ce49251254934b541e772c2cb078ba7cba84b3a11d35c430"
    sha256 cellar: :any_skip_relocation, ventura:        "f4edec79f8504ed2ce49251254934b541e772c2cb078ba7cba84b3a11d35c430"
    sha256 cellar: :any_skip_relocation, monterey:       "f4edec79f8504ed2ce49251254934b541e772c2cb078ba7cba84b3a11d35c430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b74053dee875865d6a6c3c1eadfa9fadd0da17483401145a034a353589b3ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end