class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.7.8.tgz"
  sha256 "1ba4db24f51efd25794879669d82c3a148d5644f0a0def1910aa95f1ef2ef0d1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d3312631415cc787c5f2923180e30cb1ec6ace71110293224b4cb3ebf632de7"
    sha256 cellar: :any,                 arm64_sequoia: "d054f6d899c650fc5f75db55790759a682bb8dde13d05cef71a6f3b043dc34e6"
    sha256 cellar: :any,                 arm64_sonoma:  "d054f6d899c650fc5f75db55790759a682bb8dde13d05cef71a6f3b043dc34e6"
    sha256 cellar: :any,                 sonoma:        "9dd2f58126cff5415dfc59beb1acaf7d3718b4572b7d9c70ab706934f2c3265e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ed86690d780b5cbee07ebdc841a489a71e20f026fd8d9a0fe2b1128f9615425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5684e97b008a1c15e7aa4017b3c68646e252bdb9af57b5c6bb3f9a7d420e39f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/dtsroll/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtsroll --version")

    (testpath/"dts.d.ts").write "export type Foo = string;"

    assert_match "Entry points\n → dts.d.ts", shell_output("#{bin}/dtsroll dts.d.ts")
  end
end