class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.2.0.tgz"
  sha256 "90654c7b7c7b6be088508283f1e68f3c0a9aee44d62ffd74ebbcde7e14389970"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4a5a795a4ba0280ce677625838bdb9b4c9d8950f30e7777ab33e5764b1db075"
    sha256 cellar: :any,                 arm64_sonoma:  "e4a5a795a4ba0280ce677625838bdb9b4c9d8950f30e7777ab33e5764b1db075"
    sha256 cellar: :any,                 arm64_ventura: "e4a5a795a4ba0280ce677625838bdb9b4c9d8950f30e7777ab33e5764b1db075"
    sha256 cellar: :any,                 sonoma:        "9088864dd5d93e0474cce786671cf4459f74b9c0485e1052045652da40d8fde7"
    sha256 cellar: :any,                 ventura:       "9088864dd5d93e0474cce786671cf4459f74b9c0485e1052045652da40d8fde7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "162c466e9595c2c5ff7ed6eb46fbe67e82094ab59fdb15d54ec113d14f7deef7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end