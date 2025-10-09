class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.22.0.tgz"
  sha256 "cbb2af14437d177ba7ae9c244afc3f996408ae740bbdf4362943e9f7040c4c56"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34f5013f7000c35cba6ab20630888d35fae18d33893cfabda62c0e0c6e35f4cd"
    sha256 cellar: :any,                 arm64_sequoia: "0dda165fbff5ee461c76ef3df5327f714c5527699dcca62339116051b02f33c9"
    sha256 cellar: :any,                 arm64_sonoma:  "0dda165fbff5ee461c76ef3df5327f714c5527699dcca62339116051b02f33c9"
    sha256 cellar: :any,                 sonoma:        "c875eac7ce74b509397af00b576289809efa6f249da079c5fc8806cddfcc9d12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78290b29201cddcb97c6be8a0254c31d6cecd93f54a75470fed6946a6669c8e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d14f93ab8e242fcbdc58955bfd08e4f1d53dda4573982846ae33b5265795ea9"
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