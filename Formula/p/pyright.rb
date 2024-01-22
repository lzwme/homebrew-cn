require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.348.tgz"
  sha256 "8b511b535259dc4f11471f45ec5559250d40140931a7268371ec2d7b79bc8554"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14730133dfc07658860026df7175666d361a2613b5b74a1aef9680508a4db2d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14730133dfc07658860026df7175666d361a2613b5b74a1aef9680508a4db2d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14730133dfc07658860026df7175666d361a2613b5b74a1aef9680508a4db2d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1537973d7b20325f131a10b9415ec5a66cbcb634e72de93be1ad1dbfd053e634"
    sha256 cellar: :any_skip_relocation, ventura:        "1537973d7b20325f131a10b9415ec5a66cbcb634e72de93be1ad1dbfd053e634"
    sha256 cellar: :any_skip_relocation, monterey:       "1537973d7b20325f131a10b9415ec5a66cbcb634e72de93be1ad1dbfd053e634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bf8c0a3cc081f867d138784b5b6e42951cfe7b5ff9c09a57f614da40734e15e"
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