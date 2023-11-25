require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.185.0.tgz"
  sha256 "56a9ad5ce21c191d001d7e4e5a1def19638a4e746f2c18f98d88511e17039008"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55e3f424adb564729367eb11699060450efa01137002fba0628df05532f1fc44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55e3f424adb564729367eb11699060450efa01137002fba0628df05532f1fc44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55e3f424adb564729367eb11699060450efa01137002fba0628df05532f1fc44"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fc6eb72b0fbf03d0b48509786e81fda2104b45c581ab0862ecddad67664c70b"
    sha256 cellar: :any_skip_relocation, ventura:        "6fc6eb72b0fbf03d0b48509786e81fda2104b45c581ab0862ecddad67664c70b"
    sha256 cellar: :any_skip_relocation, monterey:       "6fc6eb72b0fbf03d0b48509786e81fda2104b45c581ab0862ecddad67664c70b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e3f424adb564729367eb11699060450efa01137002fba0628df05532f1fc44"
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