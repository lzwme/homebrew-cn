class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.7.2.tgz"
  sha256 "067ff249f5302ce51c6f2fcf44112f598cff745bd2db25778d66853fa83d8a81"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e976294f65e779a4128ee60adc7cef53b0d184324b2d6b70d70b3fc61e8033d0"
    sha256 cellar: :any,                 arm64_sequoia: "89ddad643fc6a2aee849ca5e0d931ac9227312028ffb5be99f33a535a22f8436"
    sha256 cellar: :any,                 arm64_sonoma:  "89ddad643fc6a2aee849ca5e0d931ac9227312028ffb5be99f33a535a22f8436"
    sha256 cellar: :any,                 sonoma:        "adba768f74eb9cc85007373c9527f4e8488c91f81137dc134caf652dfdd36c37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "697d054bc141a07b9246219aa0bb661ae61667372b0c03378ef9aab71a8e866e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c12d5749ec963cc1a2e9d1e8c6c6c0b4cb7bef7fcc6b34a0804b8eb5988f979"
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