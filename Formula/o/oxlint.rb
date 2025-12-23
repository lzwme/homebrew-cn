class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.35.0.tgz"
  sha256 "2b6378e6029fd48995ce1823da9a0d1fc61cad3e38263be36b137dfbe65927a6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ce2c99628038e4b2e4debf5cb9a347f2f708330d1070a0a90ae747a71f9b3ec"
    sha256 cellar: :any,                 arm64_sequoia: "d179674b3805bb5eac3d782ba38057588dafe170113d1a48bc05eb9728336cfa"
    sha256 cellar: :any,                 arm64_sonoma:  "d179674b3805bb5eac3d782ba38057588dafe170113d1a48bc05eb9728336cfa"
    sha256 cellar: :any,                 sonoma:        "183d86f31b219b72b874f2fe0c144b9743c2b172cc58d5ef65baa9b687d843c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "701a2977ef56ebcaffaad16edf00d64cfe603455094f25120227a5c51bb9c540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ffb6b8f20fafd47fdfe4e465f1c3b977e3fac20e1fcde77437922893a7b2d45"
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