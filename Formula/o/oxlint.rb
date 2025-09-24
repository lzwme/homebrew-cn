class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.17.0.tgz"
  sha256 "bf531ea49243f496c7d5499c224ad6ac5e24572ab8ee9f7e99a12d0b118fad06"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a85043b67cfe1d3216e6b22530b50277bc994d98dd3f35a0dc9a8a642b0283e3"
    sha256 cellar: :any,                 arm64_sequoia: "8a71786dddf2ccd2deae135914064777819ba81bbfdddcd86fc91725d53bfa82"
    sha256 cellar: :any,                 arm64_sonoma:  "8a71786dddf2ccd2deae135914064777819ba81bbfdddcd86fc91725d53bfa82"
    sha256 cellar: :any,                 sonoma:        "c6b1b8246fc514f89f0c33fcb08d379d1be6f6887f9d4c71863f2c66b3a70c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40c28e83e37156186831b90895fecc8e1ca4beb8dc6479b1ce84b4d7eaf08bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bfc9ef10eaddc429458c2ad150fc9d2f3be21522487d1b92feb103f05e9ad3d"
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