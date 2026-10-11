class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-10.1.0.tgz"
  sha256 "b8ac6e340253a2dad144082f9436ea1d60afa66b27f423d714302d0660854f52"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b7d4284ce43f55a997d56062560e7fe3f89ad13a5296ad8455f10149dfd062cf"
    sha256 cellar: :any,                 arm64_tahoe:       "b7d4284ce43f55a997d56062560e7fe3f89ad13a5296ad8455f10149dfd062cf"
    sha256 cellar: :any,                 arm64_sequoia:     "b7d4284ce43f55a997d56062560e7fe3f89ad13a5296ad8455f10149dfd062cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b908b6fc1948abc0f228e600ec18f43923f9337fa71617cd06c694595edf330a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "337773b8999431b6cda1ddce4886a6c43dc33adda29418146eb68cb985f51229"
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