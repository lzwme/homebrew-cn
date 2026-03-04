class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-14.0.0.tgz"
  sha256 "8267d8e6de8f4d3276973a0f7815374d039ca7a657bb5406e4a81f3e06ea6b7b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "086eafacb6197bfc575300b72b19cb44320552a8b1d01996dc5abe537fb69723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fd0f29fce35b0d965c15a41da09042af3289a7b8aeb7e16ba710b5b3e9f4d2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fd0f29fce35b0d965c15a41da09042af3289a7b8aeb7e16ba710b5b3e9f4d2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3ad891c20893295ae44b668ac2c123780fb8198b48e96f9b9a543f5ade7b7bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ab3f76a2b6503cb73f69dcf36e3186b3056ed54077bfbdfceb7b360afc65416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ab3f76a2b6503cb73f69dcf36e3186b3056ed54077bfbdfceb7b360afc65416"
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