require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.171.tgz"
  sha256 "80edaa93974eb6ea47eb110ca34d11172d91b670eea8daed0761e6a6d4890517"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25cbe909afa08f938a17dd31f7224a525c7bb666e86d7cdb01985617e22cda71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25cbe909afa08f938a17dd31f7224a525c7bb666e86d7cdb01985617e22cda71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25cbe909afa08f938a17dd31f7224a525c7bb666e86d7cdb01985617e22cda71"
    sha256 cellar: :any_skip_relocation, sonoma:         "59dfb4a92afab9fc0fe36d2ce7d855bcb229609261685cd752d77edbbafee851"
    sha256 cellar: :any_skip_relocation, ventura:        "59dfb4a92afab9fc0fe36d2ce7d855bcb229609261685cd752d77edbbafee851"
    sha256 cellar: :any_skip_relocation, monterey:       "59dfb4a92afab9fc0fe36d2ce7d855bcb229609261685cd752d77edbbafee851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "969eba34dac29f5283d86e76085d627b6fe32565e141cde1e077a8195276effc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end