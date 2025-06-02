class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.87.tgz"
  sha256 "ae48974da897b771992401243b0c37ac9595dc4dae4a02bc3553bc1b49e8b1a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d2422751daa156a3a9d394abf92d0a78c11089a62e929bb5c37a6d4b8086fb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d2422751daa156a3a9d394abf92d0a78c11089a62e929bb5c37a6d4b8086fb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d2422751daa156a3a9d394abf92d0a78c11089a62e929bb5c37a6d4b8086fb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee09389de38a88b8c5a6671da835e7ddcfa7ac8fbc55b67e786df1a86fe45ff6"
    sha256 cellar: :any_skip_relocation, ventura:       "ee09389de38a88b8c5a6671da835e7ddcfa7ac8fbc55b67e786df1a86fe45ff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d2422751daa156a3a9d394abf92d0a78c11089a62e929bb5c37a6d4b8086fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d2422751daa156a3a9d394abf92d0a78c11089a62e929bb5c37a6d4b8086fb9"
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