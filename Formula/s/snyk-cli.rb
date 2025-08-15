class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1298.3.tgz"
  sha256 "090408b4f25eb673b68e0dbec79c00031b7bdec6bc6b3a4733b90af6bc44f095"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3605b3bd7862731698e1a2481210f9f3ef7173df8b5303473308c4a4b85a5702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3605b3bd7862731698e1a2481210f9f3ef7173df8b5303473308c4a4b85a5702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3605b3bd7862731698e1a2481210f9f3ef7173df8b5303473308c4a4b85a5702"
    sha256 cellar: :any_skip_relocation, sonoma:        "70db8819387fadef26db34fae42bf174f264dd6f7c5681de443d84a7393ed8d2"
    sha256 cellar: :any_skip_relocation, ventura:       "70db8819387fadef26db34fae42bf174f264dd6f7c5681de443d84a7393ed8d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fc8e22dadbe284abc0b9d3b92ef6a458fbe7e021e69a538e5993a23cca70e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d11ec57f7cc64c0b28a1c60ba51e04373bcc4396cfd992d9d2c71d9300b6ebbd"
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