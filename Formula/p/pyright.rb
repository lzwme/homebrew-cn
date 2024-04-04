require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.357.tgz"
  sha256 "db148808cc6bb3392ab58aaf4a0ffcd5f73de752c70113ea1da86dfc1939622e"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2eb52e54e7735e61c15fe54ab410102439997dd527c65047fe134fe496d1dc3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2eb52e54e7735e61c15fe54ab410102439997dd527c65047fe134fe496d1dc3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eb52e54e7735e61c15fe54ab410102439997dd527c65047fe134fe496d1dc3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbf1b74a19a7d76b2a838831065e894409a6c713bef1abfa5a645b9207d975c9"
    sha256 cellar: :any_skip_relocation, ventura:        "bbf1b74a19a7d76b2a838831065e894409a6c713bef1abfa5a645b9207d975c9"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf1b74a19a7d76b2a838831065e894409a6c713bef1abfa5a645b9207d975c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb52e54e7735e61c15fe54ab410102439997dd527c65047fe134fe496d1dc3c"
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