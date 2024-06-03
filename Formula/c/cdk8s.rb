require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.136.tgz"
  sha256 "a60e3b11cafb053863c6d01869a0c74bf55eae2a546f6dc04146b06d0ef9c065"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bafdd0e2e9da23672d22c053ccb85a3dffd85c2bcf3fbc5f9c6450052afaef5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bafdd0e2e9da23672d22c053ccb85a3dffd85c2bcf3fbc5f9c6450052afaef5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bafdd0e2e9da23672d22c053ccb85a3dffd85c2bcf3fbc5f9c6450052afaef5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfb0c14e855fe380f94cb60e3aa70472ec169bf2becd17f939c40baeaa427823"
    sha256 cellar: :any_skip_relocation, ventura:        "bfb0c14e855fe380f94cb60e3aa70472ec169bf2becd17f939c40baeaa427823"
    sha256 cellar: :any_skip_relocation, monterey:       "bfb0c14e855fe380f94cb60e3aa70472ec169bf2becd17f939c40baeaa427823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "236174f2dc9bac561515f3da7d247db58169aa4461e363da2407b3ac2654784f"
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