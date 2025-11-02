class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://registry.npmjs.org/sherif/-/sherif-1.8.0.tgz"
  sha256 "863904967ce5241124d056ac5f5ff982e22539036e929fe5949b0d80ef991f65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bc8d472573b48a50680ca65cb9ba9a0d8dfff8494b202ae1230ae898582111d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bc8d472573b48a50680ca65cb9ba9a0d8dfff8494b202ae1230ae898582111d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bc8d472573b48a50680ca65cb9ba9a0d8dfff8494b202ae1230ae898582111d"
    sha256 cellar: :any_skip_relocation, sonoma:        "52b6c31f4ed6fdc607d5db4d88686c7e454ad68e21827b0b88059305f40defe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d6ece4f73de6e3395e55ec77bec54e75141867a2156869c580e6543d3ba31b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9dbf7ed408b1e2479422e9b4e33f29fcb4861ccc54d7a78f4c20f40698ec719"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "private": true,
        "packageManager": "npm",
        "workspaces": [ "." ]
      }
    JSON
    (testpath/"test.js").write <<~JS
      console.log('Hello, world!');
    JS
    assert_match "No issues found", shell_output("#{bin}/sherif --no-install .")
  end
end