require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1281.0.tgz"
  sha256 "c440c5e461c20c413f0d26f7cfa266bd1a38aac06d64c428f09b508006bdf95c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e9403e34b6dd615477ac5c2c44a577757a7b699d411c7a4b4868e7b241a9d97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32c2164dba3d377650a548d53470b48aa3b7bfb2a81786e44208ae211f040129"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b5782ce0d98555f351cca59fdcb5d21825f56b4a832dbe845b3ef97c05f5371"
    sha256 cellar: :any_skip_relocation, sonoma:         "20daf02c7a585b018da5e8856f4eef39a79c476f2b864ec363d269f6920bb355"
    sha256 cellar: :any_skip_relocation, ventura:        "c32436f17c7aa3f64bc3f1c7f1ca35db4fdb9991053f4db096ab9d81cad4daa9"
    sha256 cellar: :any_skip_relocation, monterey:       "90315a7efd27bc67997b4552fc44710ed69a5bea336428daf36fa3712da5a7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5ad48c8327066769e509f7f60d31e12c4d9efefb57614d498e9a1175678f096"
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