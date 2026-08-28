class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1307.0.tgz"
  sha256 "590cf413e521f497b4dfa83654b88aaa5e43001ebfdd0df315620b0a5c682217"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dd8ca877822d889317f0a2883d348641bd20c58c54370ef3fccc48b69323a24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dd8ca877822d889317f0a2883d348641bd20c58c54370ef3fccc48b69323a24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dd8ca877822d889317f0a2883d348641bd20c58c54370ef3fccc48b69323a24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e3d1f48ce32d331863924cb9719b1c58fc046f0d328c68a8a38d957acce9789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffedc8b6f8729f256b01c419bc28b2380df7f8e9af1ad7018c1a5c19e4334d0e"
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