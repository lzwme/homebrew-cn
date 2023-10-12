require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.331.tgz"
  sha256 "1b58122488566e1f9438822539a6079d604fa429168ab698d47593ec1ba9a9e5"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9187afa619fca981a0dd153cb45befc1f79f0cddf1b84fa9a3e1b1678a48a79b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9187afa619fca981a0dd153cb45befc1f79f0cddf1b84fa9a3e1b1678a48a79b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9187afa619fca981a0dd153cb45befc1f79f0cddf1b84fa9a3e1b1678a48a79b"
    sha256 cellar: :any_skip_relocation, sonoma:         "626d50e72f65a038d2b9a8be9655f59edfa808247fed89ebe41b86beb28d0544"
    sha256 cellar: :any_skip_relocation, ventura:        "626d50e72f65a038d2b9a8be9655f59edfa808247fed89ebe41b86beb28d0544"
    sha256 cellar: :any_skip_relocation, monterey:       "626d50e72f65a038d2b9a8be9655f59edfa808247fed89ebe41b86beb28d0544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33e4a0d5a6564b258ba2e071b05f4c8152e2372bf1ea114942dd9d070d59071a"
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