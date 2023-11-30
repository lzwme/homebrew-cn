require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1258.0.tgz"
  sha256 "885745ea5debcc0205011d34770f936c055ecb539ea212d9cb6738ffbdd6a017"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a89a5ded92e8faa2be08fe7a32ae3d2a8bb6e9b27968806d15e8a3752da6018a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dbb13218065a5e7b2a5a2c72373e9270b8c486b140688dd377882ed09f3a02b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d6bef7843dbe3de3de4bcfaaf152c2f65d852f063c33f4e22a20803e7520952"
    sha256 cellar: :any_skip_relocation, sonoma:         "55845dcdf0f2693c236de4938578450a70b17a3ee799f5aca1971f827c5cbaf4"
    sha256 cellar: :any_skip_relocation, ventura:        "ff235747fcc1df73f1de2fff322155f36dd7f5c05ce84e92e9b6b5a23d2ffca5"
    sha256 cellar: :any_skip_relocation, monterey:       "53333ad71f3d3ddfb13c98798c2d1af9165758456ccf36bd2897a1bc739141e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c558e976fd7e178d380d8d95564c88e6f769427e7baf1a48b7ff027c22cb7f9"
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