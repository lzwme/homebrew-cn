class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-3.4.2.tgz"
  sha256 "8d7c72b067d7d237ab74593e2cd517987538fed3806aad9465ab683d82542cfb"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f91f212c104c792964caa0ec59784393f828c0484d116fc699794e1704ad3ee2"
    sha256 cellar: :any,                 arm64_sonoma:  "f91f212c104c792964caa0ec59784393f828c0484d116fc699794e1704ad3ee2"
    sha256 cellar: :any,                 arm64_ventura: "f91f212c104c792964caa0ec59784393f828c0484d116fc699794e1704ad3ee2"
    sha256 cellar: :any,                 sonoma:        "ee6fa8611cd87773144755841084c3c3dea73ff0b1d775113f6e230c44bcaa5c"
    sha256 cellar: :any,                 ventura:       "ee6fa8611cd87773144755841084c3c3dea73ff0b1d775113f6e230c44bcaa5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "367fef47dfba8d8e37900d0e406ba6d7fcbb77df81fba64d225ef493a33b8551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ccfeb85dfbcaa2b105731926cc427dd42701e7434467e3753de2d1464478146"
  end

  depends_on "node"

  def install
    system "npm", "install", "--ignore-scripts", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end