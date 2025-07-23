class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1298.1.tgz"
  sha256 "522c180901777c1386c2d6300641b2c3465dd21fd1ad7ce0e31f43a9bc0744c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08cdcd46f19c6401d6861e07982df31670fd4e439fde925a1fa955b997d80846"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08cdcd46f19c6401d6861e07982df31670fd4e439fde925a1fa955b997d80846"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08cdcd46f19c6401d6861e07982df31670fd4e439fde925a1fa955b997d80846"
    sha256 cellar: :any_skip_relocation, sonoma:        "4872a592bebf5d526356952c60428041410676f511cacdd4f1907f972711a2ce"
    sha256 cellar: :any_skip_relocation, ventura:       "4872a592bebf5d526356952c60428041410676f511cacdd4f1907f972711a2ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "830a11c277db9ea912c399ed3e90df031b337b39d7ff02343fb6eb4f171ea1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8412bf0eb7c4e97febda27ee51ce969874234ed0e7e6f87c98d40f80c2a7e933"
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