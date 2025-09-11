class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-3.5.1.tgz"
  sha256 "6917d63cb059d5e36515978e70c0e41108b8481120072ddceabcd091c0e81dca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb6a646a356b4008e145f2c34768d351ca183d9a23c046897b752314ceee65fc"
    sha256 cellar: :any,                 arm64_sonoma:  "fb6a646a356b4008e145f2c34768d351ca183d9a23c046897b752314ceee65fc"
    sha256 cellar: :any,                 arm64_ventura: "ab8840f580d2be6017163ed21612e1962563ee8661b2e2869be1014f57888dc6"
    sha256 cellar: :any,                 sonoma:        "03a5c618a139ab65ffc31520ff2df33df2ec7807cbb422f26b178e3967dd54b7"
    sha256 cellar: :any,                 ventura:       "03a5c618a139ab65ffc31520ff2df33df2ec7807cbb422f26b178e3967dd54b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc0038f5cc6863c46a4f096fe3e2bea1c5d7683444e1e9bbb9e28dd775fc998e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5204beca58cf4285dad47b2cc3c88a009198d13da2135427b8ec9936676cbdf2"
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