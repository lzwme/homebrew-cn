class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-3.4.0.tgz"
  sha256 "16c67db4604d7322ab027b3b25121b02854b74fb86a969e050a176f5cb166af6"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dfde1689ca8bf3c7d6d5ffa33ee0559d544ee59156c6a7e735d2cd06a9c98d8b"
    sha256 cellar: :any,                 arm64_sonoma:  "dfde1689ca8bf3c7d6d5ffa33ee0559d544ee59156c6a7e735d2cd06a9c98d8b"
    sha256 cellar: :any,                 arm64_ventura: "dfde1689ca8bf3c7d6d5ffa33ee0559d544ee59156c6a7e735d2cd06a9c98d8b"
    sha256 cellar: :any,                 sonoma:        "da1b62e59b285a71b79fe0ab7e186c5ed355fef1ca50d23eeebc6947e0215efd"
    sha256 cellar: :any,                 ventura:       "da1b62e59b285a71b79fe0ab7e186c5ed355fef1ca50d23eeebc6947e0215efd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65e23207b1aa14f1b1c3456973820f6b3a739d79cbb0bbf2371556727df31a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4adc6b95bf97cc8b93713d3c72dfb191bd2c6fdf05b67e3413a41baa9a067906"
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