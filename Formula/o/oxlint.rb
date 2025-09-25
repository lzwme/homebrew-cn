class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.18.0.tgz"
  sha256 "5b3d3eebe440608850626f2f56f69c98c8670435a90285e1c2b8a3fbbcea4598"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e089aee476be38de1ef1579cd9c44168a10dd22a4ed45b07e0dfa0d7e002639"
    sha256 cellar: :any,                 arm64_sequoia: "9f32c80af89c9f1b29e2109f01550f1cc227ed8182abf6a048b354b3584de40c"
    sha256 cellar: :any,                 arm64_sonoma:  "9f32c80af89c9f1b29e2109f01550f1cc227ed8182abf6a048b354b3584de40c"
    sha256 cellar: :any,                 sonoma:        "f2903c68fcd5cb08e7231b4e322468ec038f8a628fad7647deda5a6e01f46488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23d984a3cce4fd67e83a3ec7b823a1d3b9e65fad4ec04e551600b57dcf9959b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "347b0ac2cb29fcfb33a38f7ef454de52b33521589a96c649d71a19c381089982"
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