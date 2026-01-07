class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-5.0.3.tgz"
  sha256 "3c9612a9d0b5e56be7df57871890187085abff69243ef86c74acea1f24ef7143"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3fda4ae248a95ebfcc0be4eaef1baad437d5d0730ff95b4b30be842491cd80eb"
    sha256 cellar: :any,                 arm64_sequoia: "66113e2047473930e0e3ad36bce80d3edf101e061641a5c0365f3952d5789551"
    sha256 cellar: :any,                 arm64_sonoma:  "66113e2047473930e0e3ad36bce80d3edf101e061641a5c0365f3952d5789551"
    sha256 cellar: :any,                 sonoma:        "cffdd242ec847d505fc35c7fb409ff3da5d88dd5d501e7ddc840540e131ad589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eae5f84f56b59039bca4495a51a8dcc282dc62f94666e6c68dda7ba541720cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7abcc2745e70cbbcb0ef92eb09f118dcaeb6894da311c96796d517c92690346"
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