class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.16.4.tgz"
  sha256 "31b3c316d31acd334042713c72f17105f9e4571a28bd3df307df050d953b5d1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09795ed53c1ee8d128eae3ecdb611db0289dfb63823414a1631796b28923fc30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09795ed53c1ee8d128eae3ecdb611db0289dfb63823414a1631796b28923fc30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09795ed53c1ee8d128eae3ecdb611db0289dfb63823414a1631796b28923fc30"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa42ccd61668c251dcf7106ee9ad3fe83b5c52c2bd25e3ae7dd725f5b715f56"
    sha256 cellar: :any_skip_relocation, ventura:       "2fa42ccd61668c251dcf7106ee9ad3fe83b5c52c2bd25e3ae7dd725f5b715f56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09795ed53c1ee8d128eae3ecdb611db0289dfb63823414a1631796b28923fc30"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end