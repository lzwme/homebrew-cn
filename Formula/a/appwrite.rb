class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-18.0.1.tgz"
  sha256 "89367bad9dd6bd23359f96ba4368c226dc50e843cb0c8d9f2a8a379b54f6a07a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4562c632e60b3b494e4ae3d16ddecedd56052d4c399354e61929f90097d2608"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7edd184169e35269143d7de60bf2f7ceb15ff0e1ed2ba13bb55ce6ec5b28c97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7edd184169e35269143d7de60bf2f7ceb15ff0e1ed2ba13bb55ce6ec5b28c97"
    sha256 cellar: :any_skip_relocation, sonoma:        "1349d801403f35118b5cc1ebf46d1a15933b3788ea403d9454c55c2867efd4d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4a2e3dfe0a3aebdaf00b7d3509cb528efc2ba6c1768afd14a26b2af842bec3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4a2e3dfe0a3aebdaf00b7d3509cb528efc2ba6c1768afd14a26b2af842bec3b"
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