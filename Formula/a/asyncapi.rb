class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-5.0.7.tgz"
  sha256 "b7f83e9534b10e9cfe1637ff536f3d531b85bb7122ee96a82edb2a68a79335e4"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5751dff04b33150091c3f61164b7441ccbda087fd1a425b4dfd9b463f6a36e0"
    sha256 cellar: :any,                 arm64_sequoia: "a2da76fdac14f4d40c1e40d7434c2dec4fe13cd31ee987810830289675a068ef"
    sha256 cellar: :any,                 arm64_sonoma:  "a2da76fdac14f4d40c1e40d7434c2dec4fe13cd31ee987810830289675a068ef"
    sha256 cellar: :any,                 sonoma:        "e77e4c2f1bc47f46ac0bc35bd4e5644273f3887dc83802eb7a5185393856af3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39ed81e19e31ee80a53ddf7e3911b4f59bb3263bbc515a851c5c4115563bae60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9210111545b31bcb45ae1f9d008d9539b610bc02f676b2570b87b75fd6a8ba0e"
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