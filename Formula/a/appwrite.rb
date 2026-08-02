class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-25.0.0.tgz"
  sha256 "9a7c6d229ce954abefa506199a77c4158053529e53ad738d04a69e98b39c7f52"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a40b9264133c7c26396d3e9e2d0d01672a063d70969887b508ce0ddbae305956"
    sha256 cellar: :any,                 arm64_sequoia: "a40b9264133c7c26396d3e9e2d0d01672a063d70969887b508ce0ddbae305956"
    sha256 cellar: :any,                 arm64_sonoma:  "a40b9264133c7c26396d3e9e2d0d01672a063d70969887b508ce0ddbae305956"
    sha256 cellar: :any,                 sonoma:        "44109aba998d6df2dddfec17cff2bb6d3a7c1d6d1fca87dfa4f4f95fa924f0d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dbb59cb0142e6432314affb1dcf02febba0bc3ad9f03d1d850591f210f4bec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67c99d7b7b56304089964e9c54287d40c79ec9b68d6930d8943f910556fe0236"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end