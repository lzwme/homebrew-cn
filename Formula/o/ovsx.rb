class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-1.1.0.tgz"
  sha256 "fd5a7704a800529ce7439ba6601bb9b945542dcc017c491fca11f7df82f4dbe2"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "61c1cf2a8e69a0dc29f9f6b1c9b5f5b85e90e904db52b754ccf1a01849354e02"
    sha256 cellar: :any, arm64_sequoia: "61c1cf2a8e69a0dc29f9f6b1c9b5f5b85e90e904db52b754ccf1a01849354e02"
    sha256 cellar: :any, arm64_sonoma:  "61c1cf2a8e69a0dc29f9f6b1c9b5f5b85e90e904db52b754ccf1a01849354e02"
    sha256 cellar: :any, sonoma:        "f3a55e1b2a838c892ccf0bf1f5e535ff89821fc1875be4b03fafc3b3d36dc554"
    sha256 cellar: :any, arm64_linux:   "d858dd27ff44691611dc86db403290fc3cc5c3c19b61690bea39d899f0f80785"
    sha256 cellar: :any, x86_64_linux:  "45d89b15b8476c88047875be96cda1b2dd5a607eaca8b8af2d306b3bb209b5d3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end