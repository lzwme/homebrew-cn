class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.210.tgz"
  sha256 "c4a24b69f3ab55f92db2348ee223e0f645e4b3783cf96c57c9082b6b06edddb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a92aafe35e671c44b361ff39a0946483af4154b9aa319c2b43113f45e9d2e5b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a92aafe35e671c44b361ff39a0946483af4154b9aa319c2b43113f45e9d2e5b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a92aafe35e671c44b361ff39a0946483af4154b9aa319c2b43113f45e9d2e5b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8da4d223080877c73ee57c6a873656a28f5053ab24a07054b548fbdef0477f96"
    sha256 cellar: :any_skip_relocation, ventura:        "8da4d223080877c73ee57c6a873656a28f5053ab24a07054b548fbdef0477f96"
    sha256 cellar: :any_skip_relocation, monterey:       "8da4d223080877c73ee57c6a873656a28f5053ab24a07054b548fbdef0477f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a92aafe35e671c44b361ff39a0946483af4154b9aa319c2b43113f45e9d2e5b4"
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