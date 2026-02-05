class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.2.1.tgz"
  sha256 "987c99e99bdd6d1051d304d0d1568be66ecfadb8320b08508758a6162e97389a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47b85ab29a003d8f25912bcead879977095706d69a990c9924c063ada6e7fccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10f4e5ca9eedfd22607657e11b08ae0340ecfa72aad9ead437174370238da266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10f4e5ca9eedfd22607657e11b08ae0340ecfa72aad9ead437174370238da266"
    sha256 cellar: :any_skip_relocation, sonoma:        "618e37979886a90f41e21c22f8939bc7c5ddab00365f823da1386f154278ea1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd66e80332fbc5de8d5bdac65de150591420ba1f182631e217d5113eb95df813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd66e80332fbc5de8d5bdac65de150591420ba1f182631e217d5113eb95df813"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end