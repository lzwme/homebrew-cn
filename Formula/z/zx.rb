class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://google.github.io/zx/"
  url "https://registry.npmjs.org/zx/-/zx-8.6.2.tgz"
  sha256 "172e5db48d7754640004cfc38bc1ba25c41680386cc7186e13bdd06bd38a62f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d9ca7119b2497a96770ed9ee9c5b9b802d8e611a585c4bfab1d9fd51e56ab8db"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mjs").write <<~JAVASCRIPT
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    JAVASCRIPT

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_path_exists testpath/"bar"

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end