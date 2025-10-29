class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1300.2.tgz"
  sha256 "494da90471f6951ccaaaf0f9167b6396518f065e84127aeb3302195b1df44665"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8043ef8a0155e82d2491ab025fce49eef006068096c61a1c09f67c1dda5024ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8043ef8a0155e82d2491ab025fce49eef006068096c61a1c09f67c1dda5024ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8043ef8a0155e82d2491ab025fce49eef006068096c61a1c09f67c1dda5024ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "4501b29b90ead3765d9f4d05b952fd93e41f17866bdc83853a6c2a3ced3e3d14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fabe1797a63a3a26525f539cbe909ed0a084c970189a76a4035b2c7fc7fea4e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ecd85d0e054683e4f8a7bbd4df3ea8a2732de0e64536dc2115a1fc5e12d0e0a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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