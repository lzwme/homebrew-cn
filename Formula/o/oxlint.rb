class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.37.0.tgz"
  sha256 "fa3510a5f6badd95cc6e0ff6ee67a18c2f034387d7b66febef934d8f7a27965d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33f7e4a965939ba5e5c7ed2846a344496df228e2a36f62a3753159bb04684a8a"
    sha256 cellar: :any,                 arm64_sequoia: "b2cb707666cb6e259f7a64fce77db2ebccb510a53eba89dd3c3188e1b642d50b"
    sha256 cellar: :any,                 arm64_sonoma:  "b2cb707666cb6e259f7a64fce77db2ebccb510a53eba89dd3c3188e1b642d50b"
    sha256 cellar: :any,                 sonoma:        "a43062ffff46fbf3c3b2094e0d11e69ca996b99f89b8948ad1fce577e6803dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92c4ef137e0996122436d43841c6a68c29257a7415e3950e549678c4e1e0e802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d6e475a75e590e40c523b3545bb06d6dbd717ceae44100a12f1412ea10c2a7a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end