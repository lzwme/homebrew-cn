class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.7.9.tgz"
  sha256 "d0cc6574b62117508c1e8ac69d220024e92330220f9ecae56b2430ecd538dbb3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "050be111193429b73f3532f93b43e81b417abf34322ddf5d8ecfbf720d2c5252"
    sha256 cellar: :any,                 arm64_sequoia: "cb406e9ef4fb92c24fc1407d45c58055e201b0e2da9a9a111a92f85128c62d6a"
    sha256 cellar: :any,                 arm64_sonoma:  "cb406e9ef4fb92c24fc1407d45c58055e201b0e2da9a9a111a92f85128c62d6a"
    sha256 cellar: :any,                 sonoma:        "1f4c09c6671abc96f8bdd8268b9ff73e785c0043ea5966dd0b6af64951ec1f3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22c90f035f9bc54c81121b517ebfb9ab42351a621dd3b12fe08f235992098fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9246e63af6471358590f4c80ba9823366890914987d0eca28a004aee0f542d34"
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