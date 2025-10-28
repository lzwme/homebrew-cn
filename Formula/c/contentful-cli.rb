class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.7.tgz"
  sha256 "2441f9dfcc94863bcecb0aa0320ad2f3531199a66ebcd211cb3f3a94994d341d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c9ea8cf20e93c2f0f5b87f1943acd1082b99b34488b679003ffe84ce69631ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c9ea8cf20e93c2f0f5b87f1943acd1082b99b34488b679003ffe84ce69631ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c9ea8cf20e93c2f0f5b87f1943acd1082b99b34488b679003ffe84ce69631ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c9ea8cf20e93c2f0f5b87f1943acd1082b99b34488b679003ffe84ce69631ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c9ea8cf20e93c2f0f5b87f1943acd1082b99b34488b679003ffe84ce69631ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "766b3dab2224b862d31abd6fee1fdd1ec101e8fafd2765974184601c5ce8654c"
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