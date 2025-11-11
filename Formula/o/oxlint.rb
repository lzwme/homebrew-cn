class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.28.0.tgz"
  sha256 "7f3aeba525e1d26deb06f91a165cd1ed389e7332cd65eef05e7123db3fb9b1c7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d90f934a457d43141023a0e24bc6e1031e13dfef5860323bf67c7d2f28bea885"
    sha256 cellar: :any,                 arm64_sequoia: "9c9ae552decb45f198b92d40bd40641bb549a03a32bf194e6f9a575a5d5bff9c"
    sha256 cellar: :any,                 arm64_sonoma:  "9c9ae552decb45f198b92d40bd40641bb549a03a32bf194e6f9a575a5d5bff9c"
    sha256 cellar: :any,                 sonoma:        "66ac80a19fc6d6b727bfffc58397499c64e81acb98acdc2fb8f24776f1aa33e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc994c0ab03c897a2dd1750fd5247abb327588f679b682f9df46178aa4e4fe35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8270f9fc8dfdfbb72fa03b2400d642a1b44ceb06b67fc4502e371c05a3521bd2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end