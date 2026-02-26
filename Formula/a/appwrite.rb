class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.6.1.tgz"
  sha256 "9ba38c8297d604cc68c80c835dff12023ebde950deaa82da1e6c5ad07d90979b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b69c6df81f75a4b3a8a612681846808c682d9eea391452ce96d108e03090a91a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fb4dcf0ce6ab2178f7ffc4a58ed786709268397a96df85e1c499ca5903c06f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fb4dcf0ce6ab2178f7ffc4a58ed786709268397a96df85e1c499ca5903c06f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "674537ca5b5ed9e8dc9dfbc540b1432a6eb7cea1200002a2719b26750dd7b601"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "095169cd861796a36ef3c0e068ed8d60f786f16be617b35414340436478f39c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "095169cd861796a36ef3c0e068ed8d60f786f16be617b35414340436478f39c2"
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