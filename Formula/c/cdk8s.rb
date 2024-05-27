require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.129.tgz"
  sha256 "33c1004d38d0c0c1994ff03976d536eed15b5aa9a39992b3bde70480823df16f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea691adbf1aeb1ce78b01bb134255b0ff3af197b13d7bc453fecbc5b748038bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e1082f7ff6f9e4a18506f3b092ca76856c7b6873b9dbe183916e87bf3950db3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "378b363498a95163b3d776516f4c0f3a3282726d49de2bbc9de43c9e302ca679"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ccdcca35216fd4e54afb5245e816eb623457ddbd70771c018905a7a4e126d4d"
    sha256 cellar: :any_skip_relocation, ventura:        "23095dde6732e2d6f2a28522ed7fa531da818d6dfb9409be8112c13d55cd362f"
    sha256 cellar: :any_skip_relocation, monterey:       "55cce7e2e6c5c6b7468a422508c78b0abf27619fc7364f9d9c50616d3f086b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c8b5f458181614cebd1a2eab52e3d2b865a72467bf55b0e14532a9ba2a19205"
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