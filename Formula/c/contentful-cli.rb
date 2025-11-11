class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.10.1.tgz"
  sha256 "52d1113182029e47ac55fc60672240e9b49c6f0b68b11666613da022e33762a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42a9645275130a1c438d3e68f20be20e327a57a99456f8c5343db578559d686b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42a9645275130a1c438d3e68f20be20e327a57a99456f8c5343db578559d686b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42a9645275130a1c438d3e68f20be20e327a57a99456f8c5343db578559d686b"
    sha256 cellar: :any_skip_relocation, sonoma:        "42a9645275130a1c438d3e68f20be20e327a57a99456f8c5343db578559d686b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42a9645275130a1c438d3e68f20be20e327a57a99456f8c5343db578559d686b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f346123baf9bddac453f10998f0575baff5005ddb7c216c71ea331d6e491b842"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end