require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1243.0.tgz"
  sha256 "ed5286d91a8c43a0759b063128f517f52c68ba6887521d1a29e6deba2613202e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fca89c53f031af93170e3fd60cce613a997b58b6eda50ef950929c10f9806dff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d42bdb65b30fce22886ceacb82200cbf361220641f7e1e10cf3f49708db1db0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d15fbf4631ecc632297f85a98f7c694cfe97d7fcbec3455a043b31832e21a91d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ede83b7d7b3d834578077d854ab39183a450cc87b13390d848a80b6faece530"
    sha256 cellar: :any_skip_relocation, ventura:        "9675bd53d76df5d6502d0b2dcff88dda8503cfafadf5fe933c75185a82253730"
    sha256 cellar: :any_skip_relocation, monterey:       "a183e6d4f3072cb77d423c79886e1d2750384ad23a67b7a0c3c7959d535bcc6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73f85d7596be8cee18804ccb1f2a184dd00e527bfbb2bd4345bcc659a7575c5c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end