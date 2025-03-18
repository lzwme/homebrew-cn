class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.16.10.tgz"
  sha256 "f4ca8d4263551b3397919e62edd19c8500505dc94d272e3de93f4a9a04f34509"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ed888e890f7e2cb82279254c9cf0934f662bec710c6849c69a3718ce982995f"
    sha256 cellar: :any,                 arm64_sonoma:  "4ed888e890f7e2cb82279254c9cf0934f662bec710c6849c69a3718ce982995f"
    sha256 cellar: :any,                 arm64_ventura: "4ed888e890f7e2cb82279254c9cf0934f662bec710c6849c69a3718ce982995f"
    sha256 cellar: :any,                 sonoma:        "4ab37acc8899e2db93499a869fbe65f5e8ce42df2e8b43b69658f2145927d7a8"
    sha256 cellar: :any,                 ventura:       "4ab37acc8899e2db93499a869fbe65f5e8ce42df2e8b43b69658f2145927d7a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de50f2d70368730b9289fb364bda5c6fa2b47f0963d001180b1a48eb49dc75d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Cleanup .pnpm folder
    node_modules = libexec"libnode_modules@asyncapiclinode_modules"
    rm_r (node_modules"@asyncapistudiobuildstandalonenode_modules.pnpm") if OS.linux?
  end

  test do
    system bin"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath"asyncapi.yml", "AsyncAPI file was not created"
  end
end