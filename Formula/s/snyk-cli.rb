class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1308.2.tgz"
  sha256 "00cccc9b6692ebb44f0a128a369ec587c1fdba39372d54dd5d81fb8e5ea0b763"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eafd92322daf39ce17bf8e4cbce6e2edec2c7c4000f598d9b44b453a8fda7a2f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eafd92322daf39ce17bf8e4cbce6e2edec2c7c4000f598d9b44b453a8fda7a2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eafd92322daf39ce17bf8e4cbce6e2edec2c7c4000f598d9b44b453a8fda7a2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "351b2edc7763e36e6d4321343161674c7ac470396e90cfa00a9e569af6dac5b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5e512a00a1dc0d5f60848de0f73b27b72024d0e6f9246f9534608333e3d67642"
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