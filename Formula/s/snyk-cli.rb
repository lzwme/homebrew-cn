require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1252.0.tgz"
  sha256 "de8aa8d0bccbb44be789ed01efdc64640951759e06bc9d85c0e0b08adb451c69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca520db6fb9977abc959c6b7d5f5939a1372f51c04efbb0932b4faf7b8c75984"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "482a05776b6f9a723d5285b7a7c84120b1b059dfb7f1ffa4b1b0b90a9e28bc1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c58bb5de6018a8727ecf07774975d7818aa41e50fa9e936d8749256c401f2f72"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf95e3efee48b32d634ea005f2cf11b3288fe90699146725735b866eee9d041e"
    sha256 cellar: :any_skip_relocation, ventura:        "af2f49b7ecdbba9d54836688917dde378d34c481f50980a5ccf49ab8a4a2dd36"
    sha256 cellar: :any_skip_relocation, monterey:       "80514d71896b66923a8c820e83231bc2b09f5acdaddced7dced79ac35d2d09c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b301bf054e4c703d1d6284a0a7a4459b5f1824c154d01ec57d9caa89127b203d"
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