require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.58.1.tgz"
  sha256 "fe3cfb14b8c9b0b80337cd5840b64bd5bee1c3fef32abf6aabd6404836ce9faa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e1d0a0a488bc345fbdfbdd34dd10eeae77e314af959cee4d2384585a062a730d"
    sha256 cellar: :any,                 arm64_ventura:  "e1d0a0a488bc345fbdfbdd34dd10eeae77e314af959cee4d2384585a062a730d"
    sha256 cellar: :any,                 arm64_monterey: "e1d0a0a488bc345fbdfbdd34dd10eeae77e314af959cee4d2384585a062a730d"
    sha256 cellar: :any,                 sonoma:         "28e4e7907dea49a55627401cf9d4d73fd2db4b3fd5561c5fff22ab32a9e039ac"
    sha256 cellar: :any,                 ventura:        "28e4e7907dea49a55627401cf9d4d73fd2db4b3fd5561c5fff22ab32a9e039ac"
    sha256 cellar: :any,                 monterey:       "5711624333f6d6284c8a28acf0f93ca4d170032f9fd8baa9eb8faa6b85cf8ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27dbe4c2aa2d5c71b90e3397862fdf1e2b4c7517ae61e3791c5715d53ac6dcf4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end