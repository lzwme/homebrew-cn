class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-17.1.0.tgz"
  sha256 "943c82c3eb3043cc0ea8546c4d945ba40127a81ed467428325d236aff46140c0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5802b992fdc7d629de013c7068b3aaed7e895b46f74d5604856d2308cc927cec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd430cda7c6cdd3e3a867858bc94f8e8db5dc717d204c54a61ad9df890432c42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd430cda7c6cdd3e3a867858bc94f8e8db5dc717d204c54a61ad9df890432c42"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b3138a005efde2e65ad28d2ec22fceabb14bcc8dc670f07c9d5f1b09b990f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de5078ede235680e3b52d15c8e342282c0c9a8efe8b05e6eb8380f18a2c30d4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de5078ede235680e3b52d15c8e342282c0c9a8efe8b05e6eb8380f18a2c30d4c"
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