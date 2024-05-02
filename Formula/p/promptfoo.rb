require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.57.0.tgz"
  sha256 "633da7150bae0b1ee5c0090e0a063bb882b8ee7e5b9eff42e3f59c595e6beddd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9acff8e11895c52487fc424a8dfa11713af97e47d339d42d40c8c57583dbe205"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9c0f31d9cdf639db3511d927d700c5e27e988eab82db1841807c05bd1284489"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd2237956e89fa2f5fd410c73e80ce694cee6ddbad3bba818d003497b206a1e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef9b4799c6e3f473146d68489c122f37c959809abb119bcf46369be37dae1498"
    sha256 cellar: :any_skip_relocation, ventura:        "262fce7f54e0dc75e966a1501ac42f2d29019a9f86601d95f155d0f1e1774334"
    sha256 cellar: :any_skip_relocation, monterey:       "038d3bb42826080a25dca7444081908250d2ec83926da5c964b34c0e938cb315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e6ab29a4fb9a163114e8451a2218e5806ba111ecce39ac03deb760d80dbe666"
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