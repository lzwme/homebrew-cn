class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.206.tgz"
  sha256 "dc0507746cb74051738e7f3192c6b79633c3628997ca61b746bc42eec043de7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ed576bdb8cb80333783ad0a5663a859181b8993b03d7640904b2dee81ddec52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ed576bdb8cb80333783ad0a5663a859181b8993b03d7640904b2dee81ddec52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ed576bdb8cb80333783ad0a5663a859181b8993b03d7640904b2dee81ddec52"
    sha256 cellar: :any_skip_relocation, sonoma:         "8208411f7d10a62c081ea5eb05675952c152d6a312f918a2b281ca749c344249"
    sha256 cellar: :any_skip_relocation, ventura:        "8208411f7d10a62c081ea5eb05675952c152d6a312f918a2b281ca749c344249"
    sha256 cellar: :any_skip_relocation, monterey:       "8208411f7d10a62c081ea5eb05675952c152d6a312f918a2b281ca749c344249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ed576bdb8cb80333783ad0a5663a859181b8993b03d7640904b2dee81ddec52"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end