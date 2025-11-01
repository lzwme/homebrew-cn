class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://registry.npmjs.org/sherif/-/sherif-1.7.1.tgz"
  sha256 "92395b03f70eab32d28f72ab62ff54a2b300836c260b719b92f35dd67922f982"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b7216706e172861e0c293fd288ac2574a893d2efdbde819391949c972aa507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43b7216706e172861e0c293fd288ac2574a893d2efdbde819391949c972aa507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43b7216706e172861e0c293fd288ac2574a893d2efdbde819391949c972aa507"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5e88b33b1c59f0ad1e79e5d8083b56e6d72892381cf519e3b56f9e0043fc6b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a82319cf5762de794c8d5bd868446d85c54f5b6cc8179db41e3fcc8528817d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "497e5835400bcb34efbfffba4ca2a90c5cbd983f04c7514fc5cb55dee7ac81fe"
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