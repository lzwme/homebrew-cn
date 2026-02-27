class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1303.0.tgz"
  sha256 "aeb47a123fd629af3498cea29698c9d36275af4e53d2718ce18eea1adcff03ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "824f958a21dea0517b81b5e441e6e6d4da0bd829fd2265b982e7fc6919afe26e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824f958a21dea0517b81b5e441e6e6d4da0bd829fd2265b982e7fc6919afe26e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "824f958a21dea0517b81b5e441e6e6d4da0bd829fd2265b982e7fc6919afe26e"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb79d087d172c6ee4df9094fd10d82b65ec6bb49b81d9deeaa0c9be297cd2cec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41a1d5d031586a8ff53c3b338be6dd32c1d506a3d5724fd36c5c3d15360bca98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e33c7e24443fcd197c95c1a4057f3df2dc4cdfbf736587c7d442a214e21227"
  end

  depends_on "node"

  def install
    # Highly dependents on npm scripts to install wrapper bin files
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove x86-64 ELF binaries on incompatible platforms
    # TODO: Check if these should be built from source
    rm(libexec.glob("lib/node_modules/snyk/dist/cli/*.node")) if !OS.linux? || !Hardware::CPU.intel?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end