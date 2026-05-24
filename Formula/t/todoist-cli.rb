class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.67.1.tgz"
  sha256 "54d5f81df9318faf73d03f9e88a2ab67a8da9d3e717ff2fc36fe95d01d287c88"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6bb48e92f167184d21b2a267ce0726b5fbced7154471b7c5ff7d5fbe27f49082"
    sha256 cellar: :any,                 arm64_sequoia: "34e3a8dc85ab16469f51065b7add5c7bed6f0ca3cbf5d3ebf224eefbde33f394"
    sha256 cellar: :any,                 arm64_sonoma:  "34e3a8dc85ab16469f51065b7add5c7bed6f0ca3cbf5d3ebf224eefbde33f394"
    sha256 cellar: :any,                 sonoma:        "36d9abb1dacfeb9da0c95dffcdc42f92c206bfdb1dc9b517d60ba2d2b3cfe532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ecb36d1de591a37dda4ade6c6073dd324014b626908887461196f7081ae7111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bf5e04541244f213f53c036ecbd46c5666c519f747c5c74c30c28a9b4ec2ca1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end