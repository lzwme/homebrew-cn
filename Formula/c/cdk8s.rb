require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.134.0.tgz"
  sha256 "f3a87c0cab18bd46629e8158ed9c6fdf2f1ece7f19d280d61b976f2c2ade2b6b"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd9d76ec9a496bc587a9db0688a31e049afd496c83b565340ddbe8fb67fd092f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd9d76ec9a496bc587a9db0688a31e049afd496c83b565340ddbe8fb67fd092f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd9d76ec9a496bc587a9db0688a31e049afd496c83b565340ddbe8fb67fd092f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bd78f4c3c9efe4f86a190bb610912302f89ba64cc9559e9bacc60d85e751019"
    sha256 cellar: :any_skip_relocation, ventura:        "9bd78f4c3c9efe4f86a190bb610912302f89ba64cc9559e9bacc60d85e751019"
    sha256 cellar: :any_skip_relocation, monterey:       "9bd78f4c3c9efe4f86a190bb610912302f89ba64cc9559e9bacc60d85e751019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd9d76ec9a496bc587a9db0688a31e049afd496c83b565340ddbe8fb67fd092f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end