require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.353.tgz"
  sha256 "e61f949810e943b4d395045975b3711602bc49a31e2f91b64da66085683954e1"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5345da9798b1c10e3c53bd4428d5521b1e9de34c3375e811097ff19613346004"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5345da9798b1c10e3c53bd4428d5521b1e9de34c3375e811097ff19613346004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5345da9798b1c10e3c53bd4428d5521b1e9de34c3375e811097ff19613346004"
    sha256 cellar: :any_skip_relocation, sonoma:         "f76f851fadaebc3fbf08221b8524ecd598fb35ac601de55b6d6409125529602b"
    sha256 cellar: :any_skip_relocation, ventura:        "f76f851fadaebc3fbf08221b8524ecd598fb35ac601de55b6d6409125529602b"
    sha256 cellar: :any_skip_relocation, monterey:       "f76f851fadaebc3fbf08221b8524ecd598fb35ac601de55b6d6409125529602b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5345da9798b1c10e3c53bd4428d5521b1e9de34c3375e811097ff19613346004"
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