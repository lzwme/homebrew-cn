class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.124.tgz"
  sha256 "b194b8b756cc58a2668c34a3c3f383132736888608c88ec7d3bad73ea4ca3084"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70f769d7a5fe870b4c5ef41e0151e10329dc04fac63a174e65b68e8d4cfe3175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70f769d7a5fe870b4c5ef41e0151e10329dc04fac63a174e65b68e8d4cfe3175"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70f769d7a5fe870b4c5ef41e0151e10329dc04fac63a174e65b68e8d4cfe3175"
    sha256 cellar: :any_skip_relocation, sonoma:        "5647252fce6e3a5082495433218afeae03e580394fc0306c6f50681f2b69cd42"
    sha256 cellar: :any_skip_relocation, ventura:       "5647252fce6e3a5082495433218afeae03e580394fc0306c6f50681f2b69cd42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70f769d7a5fe870b4c5ef41e0151e10329dc04fac63a174e65b68e8d4cfe3175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70f769d7a5fe870b4c5ef41e0151e10329dc04fac63a174e65b68e8d4cfe3175"
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