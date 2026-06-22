class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.1.2.tgz"
  sha256 "e91f3fab4667e63fb94ce9ef5c8c3ff2c362b8a1d8d0c1689a03aa73b7f6b768"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67e1f9d7aa22f4d2a289d74a71a69c964f6fc105549e234d8b6f03ff49709f47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f82c134dde0a025b1082d9bd87a890b9e96cd757ec085b0b56bab69dd36af8b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f82c134dde0a025b1082d9bd87a890b9e96cd757ec085b0b56bab69dd36af8b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f27b72ff4f296348684065c9ab365fd5c2c5872400fd13c65be743ea8a61a3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "423e86e50f5885397c5acc16bb446e86483c97b8d64aeabf08055b52e118772f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "423e86e50f5885397c5acc16bb446e86483c97b8d64aeabf08055b52e118772f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end