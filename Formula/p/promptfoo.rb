require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.58.1.tgz"
  sha256 "bd105d90cea04d76aec055093f5fa9b48114c47326b3769089c4dcdadf00c089"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6182fc17ad36d69a465f54b67d604bffbac75fc4277e31bdf5c17cfadd1ea33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b13340c7055afa9184dbef63c0aca4bd95d10d7b14b71cdf34dbe65e8f5324d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45223da0b8145aa4d98595b9ca7b2ae67ec7ccc1e67bf2ffbb87643f664d9c97"
    sha256 cellar: :any_skip_relocation, sonoma:         "3038653bc96746179a5eeec2ada2320cb27ba5fac65adf92b0c11ab7f703a501"
    sha256 cellar: :any_skip_relocation, ventura:        "2bff446b6a7979e5044ed753287a6e1e34ad8f527feafc823a03d0b6b6c3ed7a"
    sha256 cellar: :any_skip_relocation, monterey:       "5f56f8bb2dc4d8b3cf992a4cb8d45f310ea999fa97795da7c4212e00f4f6154e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcf70bf9fdd4c880c686a4df539d8b31f6e1a5ab5f2acebb2c296c5184581f47"
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