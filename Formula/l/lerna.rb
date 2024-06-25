require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.1.5.tgz"
  sha256 "ca64d20bacf9c6c8317370ae95f67edc10bcadc777d11f9b0d447435de92b6bc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd6ac691505db77e434cfe2b4d807487ce95f8dde53126bcb3c35de9bafadbf7"
    sha256 cellar: :any,                 arm64_ventura:  "cd6ac691505db77e434cfe2b4d807487ce95f8dde53126bcb3c35de9bafadbf7"
    sha256 cellar: :any,                 arm64_monterey: "cd6ac691505db77e434cfe2b4d807487ce95f8dde53126bcb3c35de9bafadbf7"
    sha256 cellar: :any,                 sonoma:         "50697925f3dca6390f7096ff03d532dc870f952706c815d6676e4510ae05b3a0"
    sha256 cellar: :any,                 ventura:        "50697925f3dca6390f7096ff03d532dc870f952706c815d6676e4510ae05b3a0"
    sha256 cellar: :any,                 monterey:       "50697925f3dca6390f7096ff03d532dc870f952706c815d6676e4510ae05b3a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cce354d42dd55148d7f9268cf4c9d5dc7abbfea6954283a5174cea50833aa86"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end