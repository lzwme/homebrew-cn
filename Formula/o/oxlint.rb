class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.20.0.tgz"
  sha256 "f084c605a4a5a87537298323f5c09f6a62b4f563f486bfcc43e7bea673c02492"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef5432df8378ebf1c1f12c2f621ff73759ef41f749b91840cd78fc3e3bc46cfb"
    sha256 cellar: :any,                 arm64_sequoia: "0d0e7fc6a59b7cc4c735bab0bd58908333fa4dcbd9bf7075730aa34986fdacfe"
    sha256 cellar: :any,                 arm64_sonoma:  "0d0e7fc6a59b7cc4c735bab0bd58908333fa4dcbd9bf7075730aa34986fdacfe"
    sha256 cellar: :any,                 sonoma:        "dc5776d5585271e5216a1b58d6206743ebca5aa614fa8d8108290068b1c6cf73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c42653d6ca4f2241452c9a01ca03987bf50dcbd18f36f25cf26515d8b6166cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e3f4c5c283e6266750e32ec05df392291d9096d124ff025d0a667c6523c1645"
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