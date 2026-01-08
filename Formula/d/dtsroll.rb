class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.5.0.tgz"
  sha256 "0df47a60f01130264f7f314f82d65dcf3782c215782ab7bb2da7134edaab3b3e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02337408e752e67f6d6b725cf4d5c2a4c0dcfc1c283c95cf4f364e2fb768cd5b"
    sha256 cellar: :any,                 arm64_sequoia: "ab9c7973db2b2d25d0bbfa5a3b44b9ac3d06db3f03f06a091ee9182492148f5e"
    sha256 cellar: :any,                 arm64_sonoma:  "ab9c7973db2b2d25d0bbfa5a3b44b9ac3d06db3f03f06a091ee9182492148f5e"
    sha256 cellar: :any,                 sonoma:        "a3066634f189858201db0c759d9106e7fe93c8fd49516745c4d75b8fe23a4868"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69afeae6b962d4f188e5f6c544248c827d4adb9d83bba087e155586822344fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc32d1880e603172174a2130b27c78de087eaff197c7a9de86d6eda5c51b9c0f"
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