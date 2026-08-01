class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-10.0.0.tgz"
  sha256 "f31a48f2a785166aa065ebe68e96eacffbe77b2f4f918a46b285eb0c7f402161"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e716eeee6c014d5d248eb2e4e6d80a21b5702345a40e9c909f0dd61532e792db"
    sha256 cellar: :any,                 arm64_sequoia: "e716eeee6c014d5d248eb2e4e6d80a21b5702345a40e9c909f0dd61532e792db"
    sha256 cellar: :any,                 arm64_sonoma:  "e716eeee6c014d5d248eb2e4e6d80a21b5702345a40e9c909f0dd61532e792db"
    sha256 cellar: :any,                 sonoma:        "81f0a229e1a7cd6c6bfadf3acfd632363256e73256d2499abaf22b17036c861f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eb3f8320105fd16fd261114b42db67e2cebbf08a0e3e7d6f77d7388c76f91ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f2ccff9a4a3a3f1e2fff3cb80c0972ea16270d74d1b68d51fae7652af1a51f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end