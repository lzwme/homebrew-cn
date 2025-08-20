class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-3.3.0.tgz"
  sha256 "ac79fed2d954b490fb3c5e62c5c9fe180abf6efe5dc56f3db4b5e9b6f6fc8eef"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3eda7bda4d45d125f5d41c0b465b9d2cdb4e2006567d52c141fdb6a4b35a7862"
    sha256 cellar: :any,                 arm64_sonoma:  "3eda7bda4d45d125f5d41c0b465b9d2cdb4e2006567d52c141fdb6a4b35a7862"
    sha256 cellar: :any,                 arm64_ventura: "3eda7bda4d45d125f5d41c0b465b9d2cdb4e2006567d52c141fdb6a4b35a7862"
    sha256 cellar: :any,                 sonoma:        "c86f384b98dbd298ba7353cd4ae09d5198d2e2f05b53d5859b7cde6ca2e18548"
    sha256 cellar: :any,                 ventura:       "c86f384b98dbd298ba7353cd4ae09d5198d2e2f05b53d5859b7cde6ca2e18548"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "060b9d58dc660613c46bc3297fb95ee3ed2faefb77f3cf9bac1c6ce9a16209d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d31235359d53ff212c82a976c6c32824ce0eadce0741e1579fa61896e444643"
  end

  depends_on "node"

  def install
    system "npm", "install", "--ignore-scripts", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end