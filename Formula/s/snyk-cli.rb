class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1301.1.tgz"
  sha256 "ef775cda275765ace425a8d75dcfdeb2a74c0402806e2f1cefc77c4993c7c4ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c766953da53bc7389a1fff0aefabdb91224d8f206d0789521d9b5bd466db9811"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c766953da53bc7389a1fff0aefabdb91224d8f206d0789521d9b5bd466db9811"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c766953da53bc7389a1fff0aefabdb91224d8f206d0789521d9b5bd466db9811"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b8a7266258cd974156953f32811cc6bef34e43876482aba84dea600f13d0f5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b26a783eb970983e48cd661323dc5236fd6a58e8a7b15da6663e0ae6183846dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab78ab74d014bb1487148cc4a1c00e640cb1b6016485bbc5d285d7b0e63c5bf4"
  end

  depends_on "node"

  def install
    # Highly dependents on npm scripts to install wrapper bin files
    system "npm", "install", *std_npm_args(ignore_scripts: false)
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