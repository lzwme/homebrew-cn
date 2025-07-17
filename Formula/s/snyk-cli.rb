class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1298.0.tgz"
  sha256 "ff677398e1cb27457cd721bee7f85225bcf5229d2ac7c3a5355eb206e9ce9f0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e181cad438aa64563410e0ce3c12d5bbc56d2a8eaa8e3b049e3491b05dfe397c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e181cad438aa64563410e0ce3c12d5bbc56d2a8eaa8e3b049e3491b05dfe397c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e181cad438aa64563410e0ce3c12d5bbc56d2a8eaa8e3b049e3491b05dfe397c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd43b733175bb4c9fd574b6be7a2202d07abd8b5a12a76a3459624752970e692"
    sha256 cellar: :any_skip_relocation, ventura:       "dd43b733175bb4c9fd574b6be7a2202d07abd8b5a12a76a3459624752970e692"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35477bb6977fe28df2041bd0cade1d537f762c215d32b24b72e78d1e4862f925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd48c1ea2c1e333980d7e9310a4a3ef25dcae68708435a3bfbe2d92f551ef0ca"
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