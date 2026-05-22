class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1305.0.tgz"
  sha256 "f16e244278c59c9d22eeb9db229aa12a451cc6c580f4dc55bf5fa16a42429d32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa0e9f1691a356c3564d42278cf5644c07ee97f8a07b4209cda09efe7e277feb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa0e9f1691a356c3564d42278cf5644c07ee97f8a07b4209cda09efe7e277feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa0e9f1691a356c3564d42278cf5644c07ee97f8a07b4209cda09efe7e277feb"
    sha256 cellar: :any_skip_relocation, sonoma:        "949a504579c6556d8e543091b1c055f9a51547d68c7ea40ac62ad6ff6ed10576"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2664ee8a5a69f0adf7240ab2d3849fa7d29514c7d91eb26a076e75d5b73586c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96d04080f5dd23d18a9bc3231aa28745e06d8df156c12a793bd2ad6c9e225c4d"
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