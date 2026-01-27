class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.7.4.tgz"
  sha256 "4502657be55a59c8c1936eca4fab8ece0dc53b0fb62cc30500138953834d4735"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4be56c44207759aea6ed75e09d2702e7ade5c79cb82c1150f5ddb82398400559"
    sha256 cellar: :any,                 arm64_sequoia: "b2b7a8a60127bddece4530f6a564da9f1a809ab6044144c0cd1b958ba2939ace"
    sha256 cellar: :any,                 arm64_sonoma:  "b2b7a8a60127bddece4530f6a564da9f1a809ab6044144c0cd1b958ba2939ace"
    sha256 cellar: :any,                 sonoma:        "6d2298f4b6669ad0345561d5f551b3a0a63cf9061854ad16584236152d69567d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac49a035bc1d2e81b8a0f90de73bdcdb8e99c0f282947bbe1192a2e4e0125d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fde7cc0346b36a1157519db13e0e49dd014545d9f4f0ef1884ffbb13d8485ba"
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