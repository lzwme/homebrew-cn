class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.36.0.tgz"
  sha256 "828498570a5727ea56271ed4d8147e4fd5e92f3b7c9f2a1c2ef834f256ecfef3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "169a75f52fb28c7ba8e0919af3dda3e1a915071fe6aa299e9e53d185e9ad23d4"
    sha256 cellar: :any,                 arm64_sequoia: "3eeaef0bedd950990f97751f1c801da2cc377697dd3624277c2d84386ce9647e"
    sha256 cellar: :any,                 arm64_sonoma:  "3eeaef0bedd950990f97751f1c801da2cc377697dd3624277c2d84386ce9647e"
    sha256 cellar: :any,                 sonoma:        "fda3f804eb5e44bc8f9949d8d2e40c8a7c4ae0a481576b485311dfbafd751ec7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1fd97c81fa4f76f1e43b50727fa9ec2603cae1b8c0a4013ba6f58687dc92d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7497d374250668b09c8959b4d067221b533bd664bef003a48e2b679c232986be"
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