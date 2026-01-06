class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-5.0.2.tgz"
  sha256 "645583d768e8346d9c8362f554597b41683fce088e60a9a12f74e121516e8fa0"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62532a37b07f1848a960da4298a6df8f09012f7f86820379dc401f9f8d90e90e"
    sha256 cellar: :any,                 arm64_sequoia: "d2f85936a95b540d0ae26df88b9e86531084f7059ec2050c64412fa34fdb5787"
    sha256 cellar: :any,                 arm64_sonoma:  "d2f85936a95b540d0ae26df88b9e86531084f7059ec2050c64412fa34fdb5787"
    sha256 cellar: :any,                 sonoma:        "7a7273683a64b7a76d4baddba3adaf1c2c1d9b221f8276be24f900d0bbe8b58e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "becbf0ed79f2d3c0b9dcd71d9a76bb344ebb61bfb1de84b6f9cd834e5c3af07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "438afa9f36cd8dd742f877f9e8c34b655837b0725d137dde00acec8d5e41765b"
  end

  depends_on "node"

  def install
    # Set the log directory to var/log/asyncapi
    inreplace "lib/utils/logger.js", /const logDir = .*;/, "const logDir = '#{var}/log/asyncapi';"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"

    (var/"log/asyncapi").mkpath
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end