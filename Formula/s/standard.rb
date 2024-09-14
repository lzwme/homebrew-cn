class Standard < Formula
  desc "JavaScript Style Guide, with linter & automatic code fixer"
  homepage "https://standardjs.com/"
  url "https://registry.npmjs.org/standard/-/standard-17.1.1.tgz"
  sha256 "b763344dd2c24f00d8690d881c826c8f23f67d7afe616d7ad1889fd3b4d144f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cea2a79e439c36424a58621b3265e88e63516b8b2ad4e42618a63190e7c1b708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cea2a79e439c36424a58621b3265e88e63516b8b2ad4e42618a63190e7c1b708"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cea2a79e439c36424a58621b3265e88e63516b8b2ad4e42618a63190e7c1b708"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cea2a79e439c36424a58621b3265e88e63516b8b2ad4e42618a63190e7c1b708"
    sha256 cellar: :any_skip_relocation, sonoma:         "38600b8d5c9330838f671c41e8e3e7b0f3a7e5eb55a1ba428186e7301e990e64"
    sha256 cellar: :any_skip_relocation, ventura:        "38600b8d5c9330838f671c41e8e3e7b0f3a7e5eb55a1ba428186e7301e990e64"
    sha256 cellar: :any_skip_relocation, monterey:       "38600b8d5c9330838f671c41e8e3e7b0f3a7e5eb55a1ba428186e7301e990e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea2a79e439c36424a58621b3265e88e63516b8b2ad4e42618a63190e7c1b708"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_foo = testpath/"foo.js"
    test_foo.write "console.log(\"hello there\")"
    output = shell_output("#{bin}/standard #{test_foo} 2>&1", 1)
    assert_match "Strings must use singlequote. (quotes)", output

    test_bar = testpath/"bar.js"
    test_bar.write "if (name != 'John') { }"
    output = shell_output("#{bin}/standard #{test_bar} 2>&1", 1)
    assert_match "Expected '!==' and instead saw '!='. (eqeqeq)", output
    assert_match "Empty block statement. (no-empty)", output

    assert_match version.to_s, shell_output("#{bin}/standard --version")
  end
end