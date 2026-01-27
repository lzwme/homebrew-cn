class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.1.0.tgz"
  sha256 "8d1a4684f97566352b43256b48cbf7bf60de098012d406a643d98df75aa04729"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb64af9cb03b48893c19cd72903bb72f8df5092e0eae5cb520e59af962ccb297"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b1b2cbd3ca47e5ae2a518941b41df1fca2e6f4bbbdf7259796591982f2f16f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1b2cbd3ca47e5ae2a518941b41df1fca2e6f4bbbdf7259796591982f2f16f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "820ce78f469b4b3206c1efea4dc22c8b4b107f36ef4f9aeeff05ea94a4ffe8da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a775afc64023abbf595551bfd69e344d47c77397410d90b4e13bc77411c57d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a775afc64023abbf595551bfd69e344d47c77397410d90b4e13bc77411c57d6"
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